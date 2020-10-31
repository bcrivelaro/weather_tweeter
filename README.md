### Instructions

Get your .env:

```bash
  $ cp .env.example .env
```

Then replace the vaules according to your OpenWeather and Twitter keys.

Install dependencies:

```bash
  $ bundle install
```

Then start server:

```bash
  $ rails server
```

If you want to run tests, run:

```bash
  $ rspec
```

### Usage

Make a POST request to `/tweets` passing `q`, `id` or `zip` and `country_code` as parameters:

```bash
  $ curl --location --request POST 'localhost:3000/tweets' \
    --header 'Content-Type: application/json' \
    --data-raw '{
      "q": "Campinas"
    }'
```

```bash
  $ curl --location --request POST 'localhost:3000/tweets' \
    --header 'Content-Type: application/json' \
    --data-raw '{
      "id": 3467865
    }'
```

```bash
  $ curl --location --request POST 'localhost:3000/tweets' \
    --header 'Content-Type: application/json' \
    --data-raw '{
      "zip": "10001",
      "country_code": "us"
    }'
```