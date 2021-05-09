class AddUserIdToImage < ActiveRecord::Migration[6.1]
  def change
    change_table :images do |t|
      t.references :user, foreign_key: true
    end
  end
end
