# Nilus - API - Backend

### Development

In order to clone a branched DB with PostgreSQL:
`pg_dump -U [username] -h [hostname] [original_db_to_clone] | psql -U [user] -d [destination_db]`

### Populate the DB

```ruby
  bundle exec rake db:create # to generate the DB

  bundle exec rake db:migrate # to create the tables

  bundle exec rake db:seed # to create the users

  bundle exec rake shippify:places:import:all # to import addresses from Shippify

  bundle exec rake shippify:places:shippers:all # to import shippers from Shippify

  bundle exec rake shippify:places:trips:month # to import current month trips from Shippify
```
