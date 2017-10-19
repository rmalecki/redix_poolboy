# RedixPoolboy

Redis connection pool using poolboy and redix libraries.
Thankfully derived from redis_poolex.

# Examples

    alias RedixPoolboy, as: Redis

    Redis.query(["SET", "key1", "value1"]) => "OK"
    Redis.query(["GET", "key1"]) => "value1"
    Redis.query(["GET", "key2"]) => :undefined

## Installation

If [available in Hex](https://hex.pm/packages/redix_poolboy), the package can be installed as:

  1. Add redix_poolboy to your list of dependencies in `mix.exs`:

        def deps do
          [{:redix_poolboy, "~> 0.0.1"}]
        end

  2. Ensure redix_poolboy is started before your application:

        def application do
          [applications: [:redix_poolboy]]
        end

## Dev Env

`make build` - setup containers
`make test` - run test cases
