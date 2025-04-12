# Usage Guide

This guide provides an overview of how to use Ruby JSONAPI to serialize your Ruby objects according to the JSON:API specification.

## Topics

- [Basic Serialization](basic-serialization.md) - Learn how to define serializers and serialize objects
- [Working with Relationships](relationships.md) - Understand how to handle relationships between resources
- [Customization Options](customization.md) - Explore ways to customize the serialization output
- [Advanced Features](advanced-features.md) - Discover advanced features like caching and sparse fieldsets

## Quick Example

Here's a quick example of how to use Ruby JSONAPI:

```ruby
# Define a serializer
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year, :rating

  has_many :actors
  belongs_to :director
end

# Serialize a single object
movie = Movie.find(1)
serializer = MovieSerializer.new(movie)
json_string = serializer.serializable_hash.to_json

# Serialize a collection
movies = Movie.all
serializer = MovieSerializer.new(movies)
json_string = serializer.serializable_hash.to_json
```

## Output Format

The serialized output follows the [JSON:API specification](https://jsonapi.org/), which structures the data with `type`, `id`, and `attributes`:

```json
{
  "data": {
    "id": "1",
    "type": "movie",
    "attributes": {
      "name": "Inception",
      "year": 2010,
      "rating": 8.8
    },
    "relationships": {
      "director": {
        "data": { "id": "3", "type": "director" }
      },
      "actors": {
        "data": [
          { "id": "5", "type": "actor" },
          { "id": "6", "type": "actor" }
        ]
      }
    }
  }
}
```

## Choose a Topic

Select one of the topics listed above to dive deeper into using Ruby JSONAPI.