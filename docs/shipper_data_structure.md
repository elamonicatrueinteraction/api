# Shipper data structure

```
- id: string
- first_name: string
- last_name: string
- gender: string
- birth_date: date
- email: string
- phone_num: string
- photo: string
- cuit: string
- cuil: string
- created_at: date
- verified: boolean
- verified_at: date
- bank_account: array of
	- number: string
	- bank: string
	- type: string
- vehicles: array of objects
    - model
    - brand
    - photo
    - patent: object
        - verified: bool
        - expiration_date: date
        - uri: string
        - data: object
    - vehicle_title: (same as patent)
    - insurance_thirds: (same as patent)
    - kit_security (same as patent)
    - vtv (same as patent)
    - free_traffic_ticket (same as patent)
    - habilitation_sticker (same as patent)
    - air_conditioner: (same as patent)
- gateway: string
- gateway_id: string
- data: object of anything
    - created_at_shippify: date 
    - enabled_at_shippify: date
    - sent_email_invitation_shippify: boolean
    - sent_email_instructions: boolean
    - comments: string
- minimun_requirements
	- driving_license: object
	
            - verified: bool
            - expiration_date: date
            - uri: string
            - data: object
        
	- is_monotributista (same as driving_license)
	- has_cuit_or_cuil: bool
	- has_banking_account: bool
	- has_paypal_account: bool
- requirements
	- habilitation_transport_food (same as driving_license)
	- sanitary_notepad (same as driving_license)
```