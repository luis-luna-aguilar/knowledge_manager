class CreateJoinTableKnowledgePiecesTags < ActiveRecord::Migration
  def up
    create_table :knowledge_pieces_tags, :id => false do |t|
      t.references :knowledge_piece, :tag
    end

    add_index :knowledge_pieces_tags, [:knowledge_piece_id, :tag_id]
  end

  def down
    remove_index :knowledge_pieces_tags, [:knowledge_piece_id, :tag_id]
    drop_table :knowledge_pieces_tags
  end
end
