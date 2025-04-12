---
layout: default
title: Installation
nav_order: 2
---

# Installation

This guide covers the installation process for Ruby JSONAPI.

## Requirements

- Ruby 2.5 or later
- Rails 5.0+ (for Rails integration features)

## Standard Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_jsonapi'
```

Then execute:

```bash
$ bundle install
```

Or install it yourself with:

```bash
$ gem install ruby_jsonapi
```

## Rails Integration

Ruby JSONAPI includes Rails integration features like generators. When used with Rails, the gem is automatically configured and ready to use.

### Generators

To generate a serializer for a model, use the Rails generator:

```bash
$ rails g serializer Movie name year director_id box_office
```

This will create:

```ruby
# app/serializers/movie_serializer.rb
class MovieSerializer
  include JSONAPI::Serializer
  attributes :name, :year, :director_id, :box_office
end
```

## Manual Configuration

If you're not using Rails, you'll need to require the gem manually:

```ruby
require 'jsonapi/serializer'
```

## Next Steps

Once you have installed Ruby JSONAPI, proceed to the [Basic Serialization](usage/basic-serialization.md) guide to learn how to use the library.