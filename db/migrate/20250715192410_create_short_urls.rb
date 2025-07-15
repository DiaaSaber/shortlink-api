# frozen_string_literal: true

class CreateShortUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :short_urls do |t|
      t.string :long_url

      t.timestamps
    end
    add_index :short_urls, :long_url
  end
end
