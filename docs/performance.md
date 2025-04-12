---
layout: default
title: Performance Considerations
nav_order: 4
---

# Performance Considerations

Ruby JSONAPI is designed to be fast and efficient. This guide covers performance considerations, benchmarks, and instrumentation options.

## Benchmarks

Ruby JSONAPI continues the performance-focused approach of its predecessors. Below are benchmark comparisons showing the library's performance against alternatives:

### Comparison with Other Libraries

When serializing the same objects, jsonapi-serializer (and fast_jsonapi before it) consistently outperforms alternatives:

- Much faster than ActiveModelSerializers
- Much faster than JBuilder
- Efficient memory usage

For more details on the benchmark methodology, see [Performance Methodology](performance_methodology.md).

## Performance Optimization Tips

### Use Caching

Enable caching for frequently accessed resources:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 12.hours
  attributes :name, :year
end
```

### Limit Included Resources

Only include related resources when necessary:

```ruby
# Instead of including all relationships
serializer = MovieSerializer.new(movie, { include: [:director, :actors, :reviews, :awards] })

# Only include what's needed for the current view
serializer = MovieSerializer.new(movie, { include: [:director] })
```

### Use Sparse Fieldsets

Request only the fields you need:

```ruby
serializer = MovieSerializer.new(movie, {
  fields: { movie: [:name, :year], actor: [:name] }
})
```

### Avoid Complex Computations in Serializers

Expensive operations in serializer methods can slow down serialization:

```ruby
# Avoid this
attribute :average_rating do |movie|
  # Expensive calculation done for every serialization
  movie.reviews.sum(:rating) / movie.reviews.count.to_f
end

# Better approach
attribute :average_rating
# Pre-calculate and store the average rating in the model
```

### Batch Database Queries

Use includes to avoid N+1 queries:

```ruby
# Instead of
movies = Movie.all
serializer = MovieSerializer.new(movies, { include: [:director, :actors] })

# Use includes to load associations efficiently
movies = Movie.includes(:director, :actors)
serializer = MovieSerializer.new(movies, { include: [:director, :actors] })
```

## Performance Instrumentation

Ruby JSONAPI includes built-in instrumentation to help you identify performance bottlenecks.

### Enabling Instrumentation

```ruby
# First, include the instrumentation module
require 'jsonapi/serializer/instrumentation'

class MovieSerializer
  include JSONAPI::Serializer
  include JSONAPI::Serializer::Instrumentation

  # ...
end
```