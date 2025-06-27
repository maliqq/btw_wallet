### Usage

Open shell using docker-compose:

`docker compose run --rm app bash`

Create BTC wallet:

`bundle exec thor btc:create`

Check balance:

`bundle exec thor btc:balance`

Send amount to specific address:

`bundle exec thor btc:send tb1... --amount <amount in sats>`
