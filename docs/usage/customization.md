# Customization Options

This guide covers various ways to customize the serialization output in Ruby JSONAPI.

## Serializer Options Reference

The following table describes all customization options available for serializers:

Option | Purpose | Example
------------ | ------------- | -------------
set_type | Type name of Object | `set_type :movie`
key | Key of Object | `belongs_to :owner, key: :user`
set_id | ID of Object | `set_id :owner_id` or `set_id { |record, params| params[:admin] ? record.id : "#{record.name.downcase}-#{record.id}" }`
cache_options | Hash with store to enable caching and optional further cache options | `cache_options store: ActiveSupport::Cache::MemoryStore.new, expires_in: 5.minutes`
id_method_name | Set custom method name to get ID of an object (If block is provided for the relationship, `id_method_name` is invoked on the return value of the block instead of the resource object) | `has_many :locations, id_method_name: :place_ids`
object_method_name | Set custom method name to get related objects | `has_many :locations, object_method_name: :places`
record_type | Set custom Object Type for a relationship | `belongs_to :owner, record_type: :user`
serializer | Set custom Serializer for a relationship | `has_many :actors, serializer: :custom_actor`, `has_many :actors, serializer: MyApp::Api::V1::ActorSerializer`, or `has_many :actors, serializer: -> (object, params) { (return a serializer class) }`
polymorphic | Allows different record types for a polymorphic association | `has_many :targets, polymorphic: true`
polymorphic | Sets custom record types for each object class in a polymorphic association | `has_many :targets, polymorphic: { Person => :person, Group => :group }`

## Key Transforms

Ruby JSONAPI supports different key transformation options for the attribute names in the serialized output.

### Available Key Transforms

- `:camel` - `first_name` becomes `FirstName`
- `:camel_lower` - `first_name` becomes `firstName`
- `:dash` - `first_name` becomes `first-name`
- `:underscore` - `firstName` becomes `first_name`

### Setting Key Transform

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  set_key_transform :camel_lower
  attributes :first_name, :last_name
end
```

## Conditional Attributes

You can conditionally include attributes:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  # Include budget only if condition is met
  attribute :budget, if: Proc.new { |movie| movie.public_budget? }

  # Include revenue only for admin users
  attribute :revenue, if: Proc.new { |movie, params|
    params && params[:admin] == true
  }
end
```

When using this feature:

```ruby
# Normal serialization (revenue not included)
serializer = MovieSerializer.new(movie)

# Admin serialization (revenue included)
serializer = MovieSerializer.new(movie, { params: { admin: true } })
```

## Dynamic Attributes

You can define attributes that compute their values dynamically:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  # Computed attribute
  attribute :full_title do |movie|
    "#{movie.name} (#{movie.year})"
  end

  # Using params
  attribute :director_info do |movie, params|
    if params && params[:detailed]
      "#{movie.director.name} (#{movie.director.nationality})"
    else
      movie.director.name
    end
  end
end
```

## Custom Attribute Blocks

For more complex attribute logic, you can use blocks:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  attribute :rating do |movie|
    if movie.ratings.any?
      (movie.ratings.sum / movie.ratings.size.to_f).round(1)
    else
      nil
    end
  end
end
```

## Global Meta Information

You can add metadata to all your serializers:

```ruby
JSONAPI::Serializer.configure do |config|
  config.meta = ->() { { api_version: '1.0' } }
end
```

## Custom Links

You can add custom links to your serialized resources:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  link(:self) { |movie| "/movies/#{movie.id}" }
  link(:related) { |movie| "/related-movies/#{movie.genre}" }
end
```

Output:

```json
{
  "data": {
    "id": "1",
    "type": "movie",
    "attributes": { "name": "Inception", "year": 2010 },
    "links": {
      "self": "/movies/1",
      "related": "/related-movies/sci-fi"
    }
  }
}
```

## Resource-Level Meta

You can add meta information to individual resources:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  meta do |movie|
    {
      years_since_release: Time.current.year - movie.year
    }
  end
end
```

This produces:

```json
{
  "data": {
    "id": "1",
    "type": "movie",
    "attributes": { "name": "Inception", "year": 2010 },
    "meta": {
      "years_since_release": 15
    }
  }
}
```

## Custom ID Method

You can specify how IDs are derived:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  # Use a custom method to get the ID
  set_id :slug

  # Or with a block for more complex logic
  set_id do |movie, params|
    params && params[:admin] ? movie.id : movie.slug
  end

  attributes :name, :year
end
```

## Next Steps

Now that you understand customization options, check out [advanced features](advanced-features.md) like caching and sparse fieldsets.