# Condo API

Server API for condo resource management.

## Requirement
Ruby 2.7.1

Postgres 12.4

## Setup / installation

1. Clone repo
2. `bundle install`
3. `rails db:setup`
4. `rails db:migrate`
5. Copy `.env.sample` to `.env` and enter information
5. `rails server -e development`

## Pagination

The API supports **optional** pagination for endpoints that return large datasets. When pagination parameters are **not provided**, endpoints return data in the original format for backward compatibility.

### Endpoints with Pagination Support

- `GET /users`
- `GET /reservations`
- `GET /elevator_bookings`
- `GET /parking/today`
- `GET /parking/past`
- `GET /parking/future`

### Usage

Add query parameters to enable pagination:
- `page` - Page number (default: 1)
- `items` - Items per page (default: 25, max: 100)

Example: `GET /users?page=2&items=50`

### Response Format

**Without pagination parameters** (backward compatible):
```json
[
  { "id": 1, "name": "User 1", ... },
  { "id": 2, "name": "User 2", ... }
]
```

**With pagination parameters** (`?page=1&items=25`):
```json
{
  "users": [
    { "id": 1, "name": "User 1", ... },
    { "id": 2, "name": "User 2", ... }
  ],
  "pagy": {
    "page": 1,
    "items": 25,
    "count": 250,
    "pages": 10,
    "last": 10,
    "prev": null,
    "next": 2
  }
}
```

## Linting

Run `rubocop` to lint.

## Testing

Run `rails test` to test.

Please consider [Sponsoring me](https://github.com/sponsors/djensenius)
