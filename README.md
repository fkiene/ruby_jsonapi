# Ruby JSONAPI

[![Gem Version](https://badge.fury.io/rb/ruby_jsonapi.svg)](https://badge.fury.io/rb/ruby_jsonapi)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A fast and efficient [JSON:API](https://jsonapi.org/) serializer for Ruby objects.

## Introduction

Ruby JSONAPI is a fork of the jsonapi-serializer gem (which was itself forked from Netflix's fast_jsonapi).
This library provides a simple and performant way to serialize your Ruby objects according to the [JSON:API specification](https://jsonapi.org/).

### Why This Fork?

The jsonapi-serializer gem provides excellent serialization performance but lacks full JSON:API specification support. This fork aims to:

1. Complete the JSON:API specification implementation
2. Add features for complex API requirements
3. Maintain backward compatibility with jsonapi-serializer
4. Preserve the performance benefits that made the original library valuable

Our focus is to create a more complete toolset while ensuring existing code continues to work without major changes.

## Features

* Fast JSON:API serialization
* ActiveModel Serializer-like DSL
* Relationship support (`has_many`, `belongs_to`, `has_one`)
* Compound documents (included resources)
* Resource-level caching
* Conditional attributes and relationships
* Key transformation (camel, dash, underscore)
* Rails integration with generators

## Upcoming Features

- [ ] **Complete Error Objects** - Full JSON:API error structure with source pointers
- [ ] **Filtering** - Standard filtering with multiple operators and strategies
- [ ] **Sorting & Pagination** - Multi-field sorting and standard pagination
- [ ] **Enhanced Relationships** - Better handling of complex relationship structures
- [ ] **Request Parsing** - Converting incoming JSON:API documents to Ruby objects
- [ ] **Resource Permissions** - Field-level and relationship-level access controls
- [ ] **HTTP Content Negotiation** - Standard media type and header support
- [ ] **Atomic Operations** - Multiple create/update/delete operations in a single request
- [ ] **Extensions Support** - Implementation of the extensions mechanism

## Benchmarks

Ruby JSONAPI is significantly faster than alternatives like ActiveModelSerializer:

![Benchmarks](docs/images/benchmarks.png)

> Benchmarks are inherited from jsonapi-serializer. See [performance methodology](docs/performance.md) for details.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_jsonapi'
```

Then execute:

```bash
$ bundle install
```

## Quick Start

Define your serializer:

```ruby
class MovieSerializer
  include JSONAPI::Serializer

  attributes :name, :year

  has_many :actors
  belongs_to :director
end
```

Serialize your objects:

```ruby
# Single object
serializer = MovieSerializer.new(movie)
json_string = serializer.serializable_hash.to_json

# Collection
serializer = MovieSerializer.new(movies)
json_string = serializer.serializable_hash.to_json
```

## Documentation

For complete documentation, please visit our [GitHub Pages site](https://fkiene.github.io/ruby_jsonapi/):

- [Installation](https://fkiene.github.io/ruby_jsonapi/installation.html)
- [Usage](https://fkiene.github.io/ruby_jsonapi/usage/index.html)
  - [Basic Serialization](https://fkiene.github.io/ruby_jsonapi/usage/basic-serialization.html)
  - [Working with Relationships](https://fkiene.github.io/ruby_jsonapi/usage/relationships.html)
  - [Customization Options](https://fkiene.github.io/ruby_jsonapi/usage/customization.html)
  - [Advanced Features](https://fkiene.github.io/ruby_jsonapi/usage/advanced-features.html)
- [Performance Considerations](https://fkiene.github.io/ruby_jsonapi/performance.html)
- [Migration from fast_jsonapi](https://fkiene.github.io/ruby_jsonapi/migration.html)
- [JSON Serialization](https://fkiene.github.io/ruby_jsonapi/json_serialization.html)

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run the tests (`rspec`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE.txt](LICENSE.txt) file for details.

## Acknowledgments

- [jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer) - The parent project
- [Netflix fast_jsonapi](https://github.com/Netflix/fast_jsonapi) - The original project
- All contributors to both projects
