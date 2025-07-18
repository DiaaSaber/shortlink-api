# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Urls', type: :request do
  let(:long_url) { 'https://www.google.com/very/long/path' }

  describe 'POST /api/v1/encode' do
    context 'with valid parameters' do
      it 'creates a new short URL and returns it' do
        expect do
          post '/api/v1/encode', params: { url: long_url }, as: :json
        end.to change(ShortUrl, :count).by(1)

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('short_url')
        expect(json_response['short_url']).to include('http://www.example.com/')
      end
    end

    context 'with invalid parameters' do
      it 'returns a bad request error if the url is missing' do
        post '/api/v1/encode', params: {}, as: :json

        expect(response).to have_http_status(:bad_request)

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('error')
        expect(json_response['error']).to eq('param is missing or the value is empty: url')
      end

      it 'returns an unprocessable entity error if the url is invalid' do
        post '/api/v1/encode', params: { url: 'not a valid url' }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors')
        expect(json_response['errors']).to include('Long url is not a valid URL')
      end
    end
  end

  describe 'GET /:short_code' do
    let!(:short_url_record) { ShortUrl.create(long_url: long_url) }
    let(:short_code) { Base62.encode(short_url_record.id + Api::V1::UrlsController::ID_OFFSET) }

    it 'redirects to the original long URL' do
      get "/#{short_code}"

      # Check for a 302 Found status, which indicates a redirect
      expect(response).to have_http_status(:found)
      expect(response.location).to eq(long_url)
    end
  end

  describe 'GET /api/v1/decode/:short_code' do
    let!(:short_url_record) { ShortUrl.create(long_url: long_url) }
    let(:short_code) do
      Base62.encode(short_url_record.id + Api::V1::UrlsController::ID_OFFSET)
    end

    context 'when the short code exists' do
      it 'returns the original long URL in JSON format' do
        get "/api/v1/decode/#{short_code}", as: :json

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('long_url')
        expect(json_response['long_url']).to eq(long_url)
      end
    end

    context 'when the short code does not exist' do
      it 'returns a not found error' do
        get '/api/v1/decode/invalidcode', as: :json

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('error')
        expect(json_response['error']).to eq('Short URL not found')
      end
    end
  end
end
