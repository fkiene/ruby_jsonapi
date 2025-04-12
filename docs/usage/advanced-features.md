---
layout: default
title: Advanced Features
parent: Usage Guide
nav_order: 4
---

# Advanced Features

This guide covers advanced features of Ruby JSONAPI including caching, sparse fieldsets, and more.

## Caching

Ruby JSONAPI supports resource-level caching to improve performance. When enabled, serializer instances will be cached based on the resource object's cache key.

### Enabling Caching

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  set_type :movie
  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 12.hours
  attributes :name, :year, :rating
end
```

### Cache Store Configuration

Ruby JSONAPI uses Rails' cache store by default. In non-Rails applications, you need to configure a cache store:

```ruby
cache_options store: ActiveSupport::Cache::MemoryStore.new, namespace: 'jsonapi-serializer', expires_in: 12.hours
```

## Sparse Fieldsets

JSON:API allows clients to request only specific fields, reducing payload size:

```ruby
serializer = MovieSerializer.new(
  movie,
  { fields: { movie: [:name], actor: [:name] } }
)
```

This limits the output to only include the specified fields:

```json
{
  "data": {
    "id": "1",
    "type": "movie",
    "attributes": {
      "name": "Inception"
    }
  }
}
```

## Helper Methods

You can define helper methods in your serializers for reuse:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  attribute :director_name do |movie|
    get_full_name(movie.director)
  end

  attribute :producer_name do |movie|
    get_full_name(movie.producer)
  end

  # Helper method
  def get_full_name(person)
    "#{person.first_name} #{person.last_name}"
  end
end
```

## Params

You can pass arbitrary parameters to the serializer, useful for conditional logic or dynamic values:

```ruby
serializer = MovieSerializer.new(
  movie,
  { params: { current_user: current_user, admin_view: true } }
)
```

Access these parameters in your serializer:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  attribute :sensitive_data do |movie, params|
    if params[:admin_view]
      {
        budget: movie.budget,
        revenue: movie.revenue,
        profit_margin: movie.profit_margin
      }
    end
  end

  attribute :can_edit do |movie, params|
    params[:current_user]&.can_edit?(movie) || false
  end
end
```

## Instrumentation

Ruby JSONAPI supports performance instrumentation:

```ruby
require 'jsonapi/serializer/instrumentation'

class MovieSerializer
  include JSONAPI::Serializer
  include JSONAPI::Serializer::Instrumentation

  # Enable instrumentation
  instrumentation_key :serialize

  attributes :name, :year
end
```

### Custom Instrumenter

You can define a custom instrumenter:

```ruby
module CustomInstrumenter
  def self.instrument(name, payload = {})
    start = Time.now
    yield
    duration = Time.now - start
    Rails.logger.info("#{name} took #{duration}ms")
  end
end

JSONAPI::Serializer.configure do |config|
  config.instrumenter = CustomInstrumenter
end
```

## Links and Meta Information

### Top-Level Links

```ruby
serializer = MovieSerializer.new(
  movie,
  {
    links: {
      self: 'https://api.example.com/movies',
      next: 'https://api.example.com/movies?page[offset]=2',
      last: 'https://api.example.com/movies?page[offset]=10'
    }
  }
)
```

### Top-Level Meta

```ruby
serializer = MovieSerializer.new(
  movie,
  {
    meta: {
      total: 100,
      pages: 10,
      page: 1
    }
  }
)
```

## Collection Serialization Control

By default, jsonapi-serializer attempts to automatically detect if the provided resource is a collection. You can explicitly control this behavior:

```ruby
# Force treat as a collection
MovieSerializer.new(resource, { is_collection: true })

# Force treat as a single resource
MovieSerializer.new(resource, { is_collection: false })
```

## Deserialization

Ruby JSONAPI currently does not support deserialization (converting JSON:API requests into Ruby objects), but we recommend using one of the following gems for this functionality:

### [JSONAPI.rb](https://github.com/stas/jsonapi.rb)

This gem provides the following features alongside deserialization:
- Collection meta information
- Error handling
- Includes and sparse fieldsets
- Filtering and sorting
- Pagination

To use JSONAPI.rb for deserialization while using Ruby JSONAPI for serialization, you'll need to configure both libraries in your application.
