# frozen_string_literal: true

class ShortUrl < ApplicationRecord
  validates :long_url, presence: true, uniqueness: true
end
