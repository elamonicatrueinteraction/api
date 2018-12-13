module Services
  class Base
    attr_reader :attributes
    def initialize(attributes = {})
      @attributes = read_map(attributes)
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

    alias [] read_attribute
    alias []= write_attribute

    private

    def define_methods!
      self.class.attributes.each do |attribute|
        define_singleton_method :email { attributes[:email] }
        define_singleton_method :email= { |value| attributes[:email] = value }
        send("#{:email}=", attributes[attribute])
      end
    end

    class Relation
      include Enumerable
      attr_reader :arguments, :root_key
      def initialize(arguments = {}, root_key = nil)
        @arguments = arguments
        @root_key = root_key
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

      def to_s
        results
      end

      def each(&block)
        to_a.each(&block)
      end

      alias to_a results

      private

      # TODO: THis doesn't belong here
      def headers
        {
          Authorization: 'Token DEFAULT_TOKEN'
        }
      end

      def build_url
        'http://localhost:3010/resources/users.json'
      end
    end

    class << self
      attr_writer :root_key
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

      def attributes(attrs = nil)
        return @attributes ||= {} if attrs.nil?

        @attributes = *attrs
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
