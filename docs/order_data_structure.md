# Order data structure

```
- id: string
- giver: Institution
- receiver: Institution
- expiration: date
- amount: decimal/float

- delivery: (belongs_to order)
    - order_id: Order
    - trip_id: Trip
    - amount: decimal/float
    - origin_id: Address
    - origin_gps_coordinates: string
    - destination_id: Address
    - destination_gps_coordinates: string
    - status: (shippify)

    - packages: (belongs_to delivery)
        - weight: int (gramo)
        - volume: int (cm3)
        - cooling: bool
        - description: long text
        - dispatch_note: file (remito)
```
