class Order < ApplicationRecord
  has_many :deliveries, dependent: :destroy
  has_many :packages, through: :deliveries

  belongs_to :giver, class_name: 'Institution'
  belongs_to :receiver, class_name: 'Institution'
end

 # +    shipper_name: 'César Sebastián González',
 # +    shipper_avatar_url: '',
 # +    pickup_start_time: '11-16-2017 09:00',
 # +    pickup_end_time: '11-16-2017 10:00',
 # +    pickup_place: 'Banco de Alimentos de Rosario',
 # +    dropoffs: [
 # +      {
 # +        start_time: '11-16-2017 12:00',
 # +        end_time: '11-16-2017 13:00',
 # +        place: 'Asociación Civil Evita Sol Naciente',
 # +      },
 # +      {
 # +        start_time: '11-16-2017 12:00',
 # +        end_time: '11-16-2017 13:00',
 # +        place: 'Asociación Civil Evita Sol Naciente',
 # +      }
 # +    ],
 # +    delivery_amount: '375.00',
 # +    package_amount: '375.00',
 # +    status: 'on_going',
 # +    package: 'Alimentos no perecederos.',
 # +    comments: 'El timbre no funciona, golpear la puerta.'
