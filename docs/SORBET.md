# Sorbet Type Checking

This project uses [Sorbet](https://sorbet.org/), a fast, powerful type checker for Ruby.

## Overview

All Ruby files in the `app/` directory have Sorbet type annotations with `# typed: false` as a baseline. This allows gradual typing - you can add more strict typing to files incrementally.

## Running Sorbet

To run the type checker locally:

```bash
bundle exec srb tc
```

This runs automatically in CI on every push and pull request via the `.github/workflows/sorbet.yml` workflow.

## Type Levels

Sorbet supports different strictness levels via the `# typed:` comment at the top of each file:

- `# typed: false` - Minimal type checking (current baseline)
- `# typed: true` - Type checks method signatures and constants
- `# typed: strict` - Requires type signatures for all methods
- `# typed: strong` - Strictest level, no untyped code allowed

## Adding Type Signatures

To add type signatures to a method, use the `extend T::Sig` and `sig` helpers:

```ruby
# typed: true

class User < ApplicationRecord
  extend T::Sig

  sig { params(email: String).returns(T.nilable(User)) }
  def self.find_by_email(email)
    find_by(email: email.downcase)
  end

  sig { returns(String) }
  def display_name
    name || email
  end
end
```

## RBI Files

RBI (Ruby Interface) files define type signatures for gems and Rails framework code:

- `sorbet/rbi/shims/rails.rbi` - Manual type definitions for Rails and gem APIs
- `sorbet/rbi/gems/` - Auto-generated (currently empty, can be populated with `srb rbi gems`)

## Configuration

Sorbet configuration is in `sorbet/config`. Current settings:

- Ignores: `/vendor/`, `/test/`, `/db/`, `/config/`, `/tmp/`, `/coverage/`
- Suppressions for known gem issues

## Resources

- [Sorbet Documentation](https://sorbet.org/docs/overview)
- [Gradual Type Checking](https://sorbet.org/docs/gradual)
- [Writing RBI Files](https://sorbet.org/docs/rbi)
