# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  describe 'validations' do
    let!(:existing_short_url) { ShortUrl.create(long_url: 'https://www.google.com') }

    it 'is invalid without a long_url' do
      short_url = ShortUrl.new(long_url: nil)
      expect(short_url).not_to be_valid
    end

    it 'is invalid if the long_url is not unique' do
      short_url = ShortUrl.new(long_url: 'https://www.google.com')
      expect(short_url).not_to be_valid
    end

    it 'is valid with a unique long_url' do
      short_url = ShortUrl.new(long_url: 'https://www.bing.com')
      expect(short_url).to be_valid
    end
  end
end
