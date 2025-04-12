---
layout: default
title: Migration Guide
nav_order: 6
---

# Migrating to Ruby JSONAPI

This guide helps users migrating from either fast_jsonapi or jsonapi-serializer to Ruby JSONAPI.

## Migration Path

Ruby JSONAPI is a direct extension of the jsonapi-serializer gem, which was itself a fork of Netflix's fast_jsonapi. This means that migration is straightforward regardless of which library you're coming from.

## Required Changes

### Gem Name

Change the gem in your Gemfile:

```ruby
# Before (if using fast_jsonapi)
gem 'fast_jsonapi'

# Before (if using jsonapi-serializer)
gem 'jsonapi-serializer'

# After
gem 'ruby_jsonapi'
```

Then run:

```bash
bundle install
```

### Namespace Changes

If you're coming from fast_jsonapi, update your namespace references:

```ruby
# Before
class MovieSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :year
end

# After
class MovieSerializer
  include JSONAPI::Serializer
  attributes :name, :year
end
```

If you're coming from jsonapi-serializer, the change is also straightforward:

```ruby
# Before
class MovieSerializer
  include JSONAPI::Serializer
  attributes :name, :year
end

# After - No change needed!
class MovieSerializer
  include JSONAPI::Serializer
  attributes :name, :year
end
```

### Converting JSON String Methods

If you're coming from fast_jsonapi and using the serialized_json method:

```ruby
# Before
json_string = MovieSerializer.new(movie).serialized_json

# After
json_string = MovieSerializer.new(movie).serializable_hash.to_json
```

### Caching Configuration

If you're using caching, update your cache configuration:

```ruby
# Before (fast_jsonapi style)
cache_options enabled: true, cache_length: 12.hours

# After
cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 12.hours
```

## Unchanged Features

Most features remain identical across all three libraries:

- Relationship definitions with `has_many`, `belongs_to`, and `has_one`
- Conditional attributes and relationships
- Meta and link support
- Compound document support with includes
- Sparse fieldsets

## Testing Your Migration

After migrating, verify your API responses remain compatible by checking:

1. The structure of serialized objects
2. Relationship behavior
3. Caching functionality (if used)
4. Conditional attribute/relationship behavior

## Getting Help

If you encounter issues during migration, you can:

- Check the [documentation](index.md)
- Open an issue on GitHub
- Review the [error handling](error_handling.md) guide if you encounter errors