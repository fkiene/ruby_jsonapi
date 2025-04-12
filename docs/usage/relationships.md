---
layout: default
title: Working with Relationships
parent: Usage Guide
nav_order: 2
---

# Working with Relationships

This guide explains how to handle relationships between resources in Ruby JSONAPI.

## Defining Relationships

Ruby JSONAPI supports the standard ActiveRecord relationship types: `belongs_to`, `has_many`, and `has_one`.

### Basic Relationship Definition

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  belongs_to :director
  has_many :actors
  has_one :soundtrack
end
```

### Relationship Output

When you serialize an object with relationships, the output includes a `relationships` section:

```json
{
  "data": {
    "id": "1",
    "type": "movie",
    "attributes": {
      "name": "Inception",
      "year": 2010
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
      },
      "soundtrack": {
        "data": { "id": "7", "type": "soundtrack" }
      }
    }
  }
}
```

## Compound Documents (Including Related Resources)

You can include related resources in the response by using the `include` option:

```ruby
serializer = MovieSerializer.new(
  movie,
  { include: [:director, :actors] }
)
```

This produces a response with an `included` section:

```json
{
  "data": {
    "id": "1",
    "type": "movie",
    "attributes": { "name": "Inception", "year": 2010 },
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
  },
  "included": [
    {
      "id": "3",
      "type": "director",
      "attributes": {
        "name": "Christopher Nolan"
      }
    },
    {
      "id": "5",
      "type": "actor",
      "attributes": {
        "name": "Leonardo DiCaprio"
      }
    },
    {
      "id": "6",
      "type": "actor",
      "attributes": {
        "name": "Joseph Gordon-Levitt"
      }
    }
  ]
}
```

### Nested Includes

You can include nested relationships with a dot notation:

```ruby
serializer = MovieSerializer.new(
  movie,
  { include: [:director, 'actors.awards'] }
)
```

## Specifying a Relationship Serializer

Sometimes you need to use a different serializer for a relationship:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  has_many :actors, serializer: :cast_member_serializer
  belongs_to :director, serializer: :film_director_serializer
end
```

You can also use a Proc to dynamically select a serializer:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  has_many :actors, serializer: Proc.new do |record, params|
    if record.comedian?
      ComedianSerializer
    elsif params[:use_drama_serializer]
      DramaSerializer
    else
      ActorSerializer
    end
  end
end
```

## Ordering Relationships

You can specify the order of `has_many` relationships:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  has_many :actors do |movie| 
    movie.actors.order(:name)
  end
end
```

## Conditional Relationships

You can conditionally include relationships:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  has_many :reviews, if: Proc.new { |movie| movie.show_reviews? }
  belongs_to :director, if: Proc.new { |movie, params| 
    params && params[:admin] == true
  }
end
```

## Links in Relationships

You can add links to relationships:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  has_many :actors, links: {
    self: -> (object) { "/movies/#{object.id}/relationships/actors" },
    related: -> (object) { "/movies/#{object.id}/actors" }
  }
end
```

The output will include these links:

```json
{
  "data": {
    "id": "1",
    "type": "movie",
    "relationships": {
      "actors": {
        "links": {
          "self": "/movies/1/relationships/actors",
          "related": "/movies/1/actors"
        },
        "data": [
          { "id": "5", "type": "actor" },
          { "id": "6", "type": "actor" }
        ]
      }
    }
  }
}
```

## Meta in Relationships

You can add meta information to relationships:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  has_many :actors, meta: Proc.new do |movie_record, params|
    { count: movie_record.actors.length }
  end
end
```

## Next Steps

Now that you understand how to work with relationships, you can explore [customization options](customization.md) for your serializers.