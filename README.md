# Nilus - API - Backend
[![Build Status](https://img.shields.io/codeship/fe7da910-3d14-0136-59ad-1ed0266f5d63/master.svg)](https://app.codeship.com/projects/290661)
[![Maintainability](https://api.codeclimate.com/v1/badges/d4885e6adb6c7d2127d1/maintainability)](https://codeclimate.com/repos/5af4aa870297440293002282/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/d4885e6adb6c7d2127d1/test_coverage)](https://codeclimate.com/repos/5af4aa870297440293002282/test_coverage)

### Development

In order to clone a branched DB with PostgreSQL:
`pg_dump -U [username] -h [hostname] [original_db_to_clone] | psql -U [user] -d [destination_db]`

### Populate the DB

```ruby
  bundle exec rake db:create # to generate the DB

  bundle exec rake db:migrate # to create the tables

  bundle exec rake db:seed # to create the users
```
