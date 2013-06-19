class CreateKnowledgePieces < ActiveRecord::Migration
  def change
    create_table :knowledge_pieces do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
