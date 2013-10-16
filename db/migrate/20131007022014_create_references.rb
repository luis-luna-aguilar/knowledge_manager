class CreateReferences < ActiveRecord::Migration

  def change
    create_table :references do |t|
      t.string :url
      t.integer :referenceable_id
      t.string  :referenceable_type
      t.timestamps
    end
  end
  
end
