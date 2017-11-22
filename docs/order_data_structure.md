# Order data structure

```
- id: string
- client: string
- seller: string
- expiration_date: string
- amount: decimal/float
- delivery: (belongs_to order)
    - order_id: string
    - trip_id: string
    - amount: decimal/float
    - origin: gps coordinates
    - destination: gps coordinates
    - status: (shippify)
    - packages: (belongs_to delivery)
        - weigth: int (gramo)
        - volume: int (cm3)
        - cooling: bool
        - description: long text
        - dispatch_note: file (remito)
```
