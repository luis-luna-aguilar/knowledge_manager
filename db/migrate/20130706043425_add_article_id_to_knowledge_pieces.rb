class AddArticleIdToKnowledgePieces < ActiveRecord::Migration
  def up
    add_column :knowledge_pieces, :article_id, :integer
    add_index :knowledge_pieces, :article_id
  end

  def down
    remove_column :knowledge_pieces, :article_id
    remove_index :knowledge_pieces, :article_id
  end
end
