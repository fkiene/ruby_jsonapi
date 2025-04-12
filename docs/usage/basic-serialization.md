# Basic Serialization

This guide covers the fundamentals of serializing Ruby objects with Ruby JSONAPI.

## Model Definition

Let's start with a sample model that we'll use throughout the documentation:

```ruby
class Movie
  attr_accessor :id, :name, :year, :actor_ids, :owner_id, :movie_type_id
end
```

In a Rails application, this would be an ActiveRecord model with relationships:

```ruby
class Movie < ApplicationRecord
  belongs_to :owner
  belongs_to :movie_type
  has_many :actors
end
```

## Serializer Definition

Creating a serializer is simple. Define a new class with the `JSONAPI::Serializer` module included:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  # Define attributes to be serialized
  attributes :name, :year
end
```

### Type Inference

By default, the type is inferred from the serializer class name:

- `MovieSerializer` will use the type `"movie"`
- `TvShowSerializer` will use the type `"tv_show"`

### Custom Type

You can specify a custom type:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  set_type :film
  attributes :name, :year
end
```

### ID Attribute

By default, the `id` method is called on the object to get its identifier. You can override this:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  set_id do |object|
    object.custom_id
  end

  attributes :name, :year
end
```

## Object Serialization

### Serializing a Single Resource

```ruby
movie = Movie.find(1)
serializer = MovieSerializer.new(movie)

# Hash representation
serializer.serializable_hash
# => { data: { id: "1", type: "movie", attributes: { name: "Inception", year: 2010 } } }

# JSON string
serializer.serializable_hash.to_json
# => '{"data":{"id":"1","type":"movie","attributes":{"name":"Inception","year":2010}}}'
```

### Collection Serialization

```ruby
movies = Movie.all
serializer = MovieSerializer.new(movies)
serializer.serializable_hash
```

The output for a collection includes an array of serialized resources:

```json
{
  "data": [
    {
      "id": "1",
      "type": "movie",
      "attributes": {
        "name": "Inception",
        "year": 2010
      }
    },
    {
      "id": "2",
      "type": "movie",
      "attributes": {
        "name": "The Matrix",
        "year": 1999
      }
    }
  ]
}
```

## Adding Metadata

You can include additional metadata in the serialized output:

```ruby
serializer = MovieSerializer.new(movie, { meta: { total: 100 } })
serializer.serializable_hash
# => { data: {...}, meta: { total: 100 } }
```

## Next Steps

Now that you understand basic serialization, learn about working with [relationships](relationships.md) between resources.