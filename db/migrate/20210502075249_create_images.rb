# frozen_string_literal: true

class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.string :canonical_id, null: false
      t.string :name, null: false
      t.string :alt_text
      t.timestamps
    end

    add_index :images, :canonical_id, unique: true, name: 'index_image_url'
  end
end
