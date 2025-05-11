require 'spec_helper'

RSpec.describe JSONAPI::Deserializer do
  class TestController < ActionController::Base
    include JSONAPI::Deserializer
  end

  subject(:deserialize) { TestController.new.method(:jsonapi_deserialize) }

  let(:document) do
    {
      data: {
        id: 1,
        type: 'note',
        attributes: {
          title: 'Title 1',
          date: '2015-12-20'
        },
        relationships: {
          author: {
            data: {
              type: 'user',
              id: 2
            }
          },
          second_author: {
            data: nil
          },
          notes: {
            data: [
              { type: 'note', id: 3 },
              { type: 'note', id: 4 }
            ]
          }
        }
      }
    }
  end

  describe '#jsonapi_deserialize' do
    context 'when deserializing a complete document' do
      it 'returns a hash with all attributes and relationships' do
        expect(deserialize.call(document)).to eq(
          'id' => 1,
          'date' => '2015-12-20',
          'title' => 'Title 1',
          'author_id' => 2,
          'second_author_id' => nil,
          'note_ids' => [3, 4]
        )
      end
    end

    context 'when using :only option' do
      subject(:deserialized_data) { deserialize.call(document, only: :notes) }

      it 'returns only specified relationships' do
        expect(deserialized_data).to eq('note_ids' => [3, 4])
      end
    end

    context 'when using :except option' do
      subject(:deserialized_data) { deserialize.call(document, except: [:date, :title]) }

      it 'excludes specified attributes' do
        expect(deserialized_data).to eq(
          'id' => 1,
          'author_id' => 2,
          'second_author_id' => nil,
          'note_ids' => [3, 4]
        )
      end
    end

    context 'when handling polymorphic relationships' do
      subject(:deserialized_data) do
        deserialize.call(document, only: :author, polymorphic: :author)
      end

      it 'includes type for polymorphic relationships' do
        expect(deserialized_data).to eq(
          'author_id' => 2,
          'author_type' => 'User'
        )
      end
    end

    context 'when document is invalid' do
      let(:invalid_document) { { data: nil } }

      it 'returns an empty hash' do
        expect(deserialize.call(invalid_document)).to be_empty
      end
    end
  end
end
