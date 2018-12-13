module Services
  class Base
    attr_reader :attributes
    def initialize(attrs = {})
      @attributes = read_map(attrs)
      @dirty = false
      define_methods!
    end

    def read_map(attributes)
      attributes.with_indifferent_access.select do |(key, _value)|
        self.class.attributes.include? key.to_sym
      end
    end

    def read_attribute(attr)
      attributes[attr.to_sym]
    end

    def write_attribute(attr, value)
      dirty!
      attributes[attr.to_sym] = value
    end

    def dirty?
      @dirty
    end

    def dirty!
      @dirty = true
    end

    def inspect
      "<#{self.class.name} \n\t#{attributes.map { |(k, v)| "#{k}: #{v.inspect}" }.join(",\n\t")}>"
    end

    alias [] read_attribute
    alias []= write_attribute
    alias to_s inspect

    private

    def define_methods!
      self.class.attributes.each do |attribute|
        define_singleton_method ("#{attribute}".to_sym) { attributes[attribute.to_sym] }
        define_singleton_method ("#{attribute}=")  { |value| attributes[attribute.to_sym] = value }
      end
    end

    class Relation
      include Enumerable
      attr_reader :arguments, :root_key, :where_chain
      def initialize(arguments = {}, root_key = nil)
        @arguments = arguments
        @root_key = root_key
        @where_chain = {}
      end

      def where(args = {})
        where_chain.merge!(args)
        self
      end

      def raw_results
        @raw_results ||= HTTParty.get(
          build_url,
          headers: headers
        )
      end

      def results
        return @results if @results

        items = root_key ? raw_results[root_key] : raw_results
        @results = items.map { |i| self.class.parent.new i }
      end

      def inspect
        results
      end

      def each(&block)
        to_a.each(&block)
      end

      alias to_a results

      private

      def query_for(key, value)
        "#{key}=#{value}"
      end

      def query_params
        where_chain.map do |(key, value)|
          query_for(key, value)
        end.join('&')
      end

      # TODO: Abstract this
      def build_url
        "#{self.class.parent.service_path}/#{self.class.parent.name.demodulize.underscore.pluralize}.json?#{query_params}"
      end

      # TODO: THis doesn't belong here
      def headers
        self.class.parent.headers
      end
    end

    class << self
      attr_writer :root_key
      delegate :where, to: :all

      def all
        find(:all)
      end

      def find(*args)
        case args.first
        when :all then find_every
        end
      end

      def root_key
        @root_key ||= self.name.demodulize.underscore.pluralize # rubocop:disable Style/RedundantSelf
      end

      def service_path(path = nil)
        return @service_path ||= self.superclass.service_path if path.nil?

        @service_path = path
      end

      def headers(headers = nil)
        return @headers ||= (self.superclass.headers || {}) if headers.nil?

        @headers = headers
      end

      def attributes(*attrs)
        return @attributes ||= [] if attrs.empty?

        @attributes = [*attrs]
      end

      private

      def find_every(options = {})
        relation(options)
      end

      def relation(options)
        const_set "Relation".to_sym, Class.new(Services::Base::Relation) if self::Relation == Services::Base::Relation
        self::Relation.new(options, root_key)
      end
    end
  end
end
