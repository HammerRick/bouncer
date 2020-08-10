# Bouncer

This is the best[citation needed] rails API to give you money!

## Getting Started

### Prerequisites

* [ruby 2.7](https://www.ruby-lang.org/en/documentation/installation/)
* [rails 6.0.3.2](https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project-installing-rails)
* [postgres 12.3](https://www.postgresql.org/download/)
* [redis 4.0.9](https://tecadmin.net/install-redis-ubuntu/)

### Preparing env variables

```shell
cp config/local_env_example.yml config/local_env.yml
```

than adjust the keys as needed.

### Installing

Install gems

```shell
bundle install
```

Create database

```shell
rails db:create
```

Run migrations

```shell
rails db:migrate
```

Make sure postgres is running, if your Linux distribution uses systemd, you can use:

```shell
systemctl status postgresql
```

If you need it, restart

```shell
systemctl restart postgresql
```

Run redis and sidekiq (in another shell)

```shell
redis-server
sidekiq
```

Run server

```shell
rails s
```

### Example usage

To use application, send requests:

```shell
# get all loans with all data
curl --location --request GET 'http://localhost:3000/api/v1/loans'

# create loan
curl --location --request POST 'http://localhost:3000/api/v1/loans/' \
--header 'Content-Type: application/json' \
--data-raw '{ "loan" : {
        "name": "name",
        "cpf": "100.000.000-07",
        "birthdate": "1994-11-03",
        "amount": "1123.32",
        "terms": 6,
        "income": "3250.42"
    } }'

>{"id":"7e87b113-9edd-48f4-99e0-0b2d16d40042"}

# check loan result
curl --location --request GET 'http://localhost:3000/api/v1/loans/7e87b113-9edd-48f4-99e0-0b2d16d40042'
>{"id":"7e87b113-9edd-48f4-99e0-0b2d16d40042","amount":"1123.32","status":"completed","result":"approved","refused_policy":null,"approved_terms":9}
```

## Running tests

With our development container running, type:

```shell
bundle exec rspec
```
