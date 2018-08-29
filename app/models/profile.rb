class Profile < ApplicationRecord
  belongs_to :user

  attribute :extras, :jsonb, default: {}

  EXTRA_INFO = %w[
    cellphone
  ].freeze
  private_constant :EXTRA_INFO

  EXTRA_INFO.each do |extra_name|
    attribute :"#{extra_name}"

    define_method :"#{extra_name}" do
      (extras['info'] || {})[extra_name]
    end

    define_method :"#{extra_name}=" do |new_value|
      self.extras['info'] = self.extras['info'] || {}

      if new_value.present?
        self.extras['info'][extra_name] = new_value
      else
        self.extras['info'].delete(extra_name)
      end
    end
  end
end
