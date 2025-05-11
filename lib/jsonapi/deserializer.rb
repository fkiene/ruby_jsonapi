begin
  require 'active_support/inflector'
rescue LoadError
  warn(
    'Trying to load `dry-inflector` as an ' \
    'alternative to `active_support/inflector`...'
  )
  require 'dry/inflector'
end

module JSONAPI
  # Provides functionality to transform JSON:API compliant documents into formats
  # suitable for ActiveRecord operations. Handles deserialization of resources,
  # including attributes, relationships, and polymorphic associations.
  #
  # @example Basic Usage in Rails Controller
  #   class ApplicationController < ActionController::Base
  #     include JSONAPI::Deserializer
  #
  #     private
  #
  #     def post_params
  #       jsonapi_deserialize(params, only: [:title, :body, :author])
  #     end
  #   end
  module Deserializer
    class DeserializationError < StandardError; end

    private

    def jsonapi_inflector
      ActiveSupport::Inflector
    rescue
      Dry::Inflector.new
    end

    # Transforms a JSON:API document into a hash suitable for ActiveRecord operations.
    #
    # @param [Hash|ActionController::Parameters] document JSON:API document
    # @param [Hash] options Deserialization options
    # @option options [Array<String,Symbol>] :only Whitelist of attributes/relationships
    # @option options [Array<String,Symbol>] :except Blacklist of attributes/relationships
    # @option options [Array<String,Symbol>] :polymorphic List of polymorphic relationships
    #
    # @example Input document
    #   {
    #     data: {
    #       id: '1',
    #       type: 'posts',
    #       attributes: { title: 'Hello World' },
    #       relationships: {
    #         author: { data: { id: '2', type: 'users' } },
    #         comments: {
    #           data: [
    #             { type: 'comments', id: '1' }
    #           ]
    #         }
    #       }
    #     }
    #   }
    #
    # @example Output
    #   {
    #     'id' => '1',
    #     'title' => 'Hello World',
    #     'author_id' => '2',
    #     'comment_ids' => ['1']
    #   }
    #
    # @return [Hash] Hash suitable for ActiveRecord create/update operations
    def jsonapi_deserialize(document, options = {})
      primary_data = extract_primary_data(document)
      return {} if primary_data.empty?

      options = normalize_options(options)

      parsed = primary_data['attributes'] || {}
      parsed['id'] = primary_data['id'] if primary_data['id']

      relationships = primary_data['relationships'] || {}

      apply_filters!(parsed, relationships, options)

      process_relationships(parsed, relationships, options)

      parsed
    end

    private

    def extract_primary_data(document)
      if document.respond_to?(:permit!)
        document.dup.require(:data).permit!.as_json
      elsif document.is_a?(Hash)
        (document.as_json['data'] || {}).deep_dup
      else
        {}
      end
    end

    def normalize_options(options)
      options = options.as_json
      ['only', 'except', 'polymorphic'].each do |opt_name|
        options[opt_name] = Array(options[opt_name]).map(&:to_s) if options[opt_name]
      end
      options
    end

    def apply_filters!(*hashes, options)
      if options['only']
        hashes.map { |hash| hash.slice!(*options['only']) }
      elsif options['except']
        hashes.map { |hash| hash.except!(*options['except']) }
      end
    end

    def process_relationships(parsed, relationships, options)
      relationships.each do |assoc_name, assoc_data|
        assoc_data = (assoc_data || {})['data'] || {}
        rel_name = jsonapi_inflector.singularize(assoc_name)

        if assoc_data.is_a?(Array)
          parsed["#{rel_name}_ids"] = assoc_data.filter_map { |ri| ri['id'] }
          next
        end

        parsed["#{rel_name}_id"] = assoc_data['id']

        if (options['polymorphic'] || []).include?(assoc_name)
          rel_type = jsonapi_inflector.classify(assoc_data['type'].to_s)
          parsed["#{rel_name}_type"] = rel_type
        end
      end
    end
  end
end
