class CreateJodelPosts < ActiveRecord::Migration
  def change
    create_table :jodel_posts do |t|
      t.string :post_id
      t.datetime :created_at
      t.datetime :updated_at
      t.string :message
      t.integer :vote_count
      t.string :color
      t.string :image_url
      t.string :thumbnail_url

      t.timestamps null: false
      t.references :jodel_city, index: true, foreign_key: true

    end

    add_index :jodel_posts, :post_id, unique: true
    add_index :jodel_posts, [:jodel_city_id, :vote_count]

  end
end
