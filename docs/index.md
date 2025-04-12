# Ruby JSONAPI Documentation

Welcome to the Ruby JSONAPI documentation. This library provides fast and efficient JSON:API serialization for Ruby objects.

## Overview

Ruby JSONAPI is a fork of the jsonapi-serializer gem (which was itself forked from Netflix's fast_jsonapi). It adheres to the [JSON:API specification](https://jsonapi.org/) while providing excellent performance.

## Features

* Declaration syntax similar to Active Model Serializer
* Support for `belongs_to`, `has_many` and `has_one`
* Support for compound documents (included)
* Optimized serialization of compound documents
* Caching

## Contents

- [Installation](installation.md)
- [Usage](usage/index.md)
  - [Basic Serialization](usage/basic-serialization.md)
  - [Working with Relationships](usage/relationships.md)
  - [Customization Options](usage/customization.md)
  - [Advanced Features](usage/advanced-features.md)
- [Performance Considerations](performance.md)
- [Migration from fast_jsonapi](migration.md)
- [JSON Serialization](json_serialization.md)

## Project Status

Ruby JSONAPI is currently in active development. While it maintains feature parity with jsonapi-serializer, we are working toward implementing the enhanced features noted in our roadmap.

## Getting Started

If you're new to Ruby JSONAPI, start with the [Installation](installation.md) guide and then move on to [Basic Serialization](usage/basic-serialization.md).