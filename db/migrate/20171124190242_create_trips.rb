class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips, id: :uuid do |t|
      t.uuid :shipper_id, index: true

      t.string :status
      t.string :comments

      t.decimal :amount, precision: 12, scale: 4, default: 0

      t.datetime :schedule_at

      t.jsonb :pickups, null: false, default: {}
      t.jsonb :dropoffs, null: false, default: {}

      t.string :gateway
      t.string :gateway_id
      t.jsonb :gateway_data, null: true, default: {}

      t.timestamps
    end
    add_foreign_key :trips, :shippers
    add_foreign_key :deliveries, :trips
  end
end

 #  shipper_name: 'César Sebastián González',
 #  shipper_avatar_url: '',

 #  pickup_start_time: '11-16-2017 09:00',
 #  pickup_end_time: '11-16-2017 10:00',
 #  pickup_place: 'Banco de Alimentos de Rosario',

 #  dropoffs: [
 #    {
 #      start_time: '11-16-2017 12:00',
 #      end_time: '11-16-2017 13:00',
 #      place: 'Asociación Civil Evita Sol Naciente',
 #    },
 #    {
 #      start_time: '11-16-2017 12:00',
 #      end_time: '11-16-2017 13:00',
 #      place: 'Asociación Civil Evita Sol Naciente',
 #    }
 #  ],
 #  delivery_amount: '375.00',
 #  package_amount: '375.00',
 #  status: 'on_going',
 #  package: 'Alimentos no perecederos.',
 #  comments: 'El timbre no funciona, golpear la puerta.'
