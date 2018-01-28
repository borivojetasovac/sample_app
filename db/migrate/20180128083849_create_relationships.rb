class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id      # Add an index to follower_id column (of relationships database) for finding efficiency
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique: true  # Enfoece uniqueness on this pair; can't follow someone more than once
  end
end
