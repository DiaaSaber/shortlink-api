# frozen_string_literal: true

module Api
  module V1
    class UrlsController < ApplicationController
      ID_OFFSET = 1_000_000_000
      # POST /api/v1/encode
      # Params: { url: "https://your-long-url.com" }
      def encode
        @short_url = ShortUrl.find_or_create_by(long_url: encode_params)

        if @short_url.persisted?
          host = request.base_url
          short_code = Base62.encode(@short_url.id + ID_OFFSET)
          render json: { short_url: "#{host}/#{short_code}" }, status: :ok
        else
          render json: { errors: @short_url.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/decode/:short_code or /:short_code
      def decode
        id = Base62.decode(params[:short_code]) - ID_OFFSET
        @short_url = ShortUrl.find_by(id: id)

        if @short_url
          if request.format.html?
            redirect_to @short_url.long_url, allow_other_host: true
          else
            render json: { long_url: @short_url.long_url }, status: :ok
          end
        else
          render json: { error: 'Short URL not found' }, status: :not_found
        end
      end

      private

      def encode_params
        params.require(:url)
      end
    end
  end
end
