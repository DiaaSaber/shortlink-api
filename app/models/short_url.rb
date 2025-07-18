# frozen_string_literal: true

class ShortUrl < ApplicationRecord
  validates :long_url, presence: true, uniqueness: true, format: {
    with: URI::DEFAULT_PARSER.make_regexp,
    message: 'is not a valid URL'
  }
end
