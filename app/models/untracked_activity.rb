# == Schema Information
#
# Table name: untracked_activity
#
#  id               :uuid             not null, primary key
#  institution_id   :uuid
#  author_id        :uuid
#  amount           :decimal(12, 4)   default(0.0)
#  reason           :string
#  activity           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  network_id       :string
#

class UntrackedActivity < ApplicationRecord
  default_scope_by_network
  include Payable

  validates :author_id, presence: {allow_blank: false, message: "El id del autor no debe ser vacío"}
  validates :institution_id, presence: {allow_blank: false,
                                        message: "El id de institución no debe ser vacio"}
  validates :amount, numericality: { greater_than: 0,
                                     message: 'El monto debe ser mayor a 0'}, on: :create
  validates :reason, presence: { allow_blank: false, message: "La razón de la transacción no debe ser vacia"}
  validates :network_id, presence: { allow_blank: false, message: "El código de red no puede ser vacio"}
  validates :activity, presence: { allow_blank: false, message: "La actividad no puede ser vacía"}

  validate :known_activity
  scope :by_institution_id, ->(id) { where(institution_id: id) }

  module Types
    ORDER = "Order"
    DELIVERY = "Delivery"
  end

  KNOWN_ACTIVITY_TYPES = [Types::ORDER, Types::DELIVERY]

  def known_activity
    is_known = KNOWN_ACTIVITY_TYPES.include?(activity)
    unless is_known
      errors[:activity] = "No se reconoce la actividad #{activity}"
    end
  end

  def institution
    @institution ||= Services::Institution.find(institution_id)
  end

  def receiver
    institution
  end

  def type
    activity
  end

end
