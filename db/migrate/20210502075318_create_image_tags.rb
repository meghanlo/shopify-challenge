class CreateImageTags < ActiveRecord::Migration[6.1]
  def change
    create_table :image_tags do |t|
      t.integer :image_id, null: false
      t.string :tag_name, null: false
      t.timestamps
    end

    add_index :image_tags, [:image_id, :tag_name], unique: true, name: "index_image_tags"
  end
end
