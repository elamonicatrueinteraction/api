module Service
  module Support
    module Finders

      FILTER_OPTIONS = {
        created_since: {
          type: Types::Params::Date,
          klass: Date
        },
        created_until: {
          type: Types::Params::Date,
          klass: Date
        }
      }.freeze
      private_constant :FILTER_OPTIONS

      private

      def filter_params
        @filter_params ||= {}
      end

      FILTER_OPTIONS.each do |filter_name, validation|
        define_method :"#{filter_name}" do
          return instance_variable_get("@#{filter_name}") if instance_variable_defined?("@#{filter_name}")

          if value = get_value(filter_name)
            instance_variable_set("@#{filter_name}", coerce_or_nil(value, validation))
          else
            instance_variable_set("@#{filter_name}", nil)
          end
        end
      end

      def get_value(key_name)
        filter_params[key_name.to_sym] || filter_params[key_name.to_s]
      end

      def coerce_or_nil(value, validation)
        value = validation[:type][value]

        value.is_a?(validation[:klass]) ? value : nil
      end
    end
  end
end
