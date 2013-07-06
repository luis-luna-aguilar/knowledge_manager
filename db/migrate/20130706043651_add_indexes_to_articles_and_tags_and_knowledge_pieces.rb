class AddIndexesToArticlesAndTagsAndKnowledgePieces < ActiveRecord::Migration
  def up
    add_index :tags, :name
    add_index :articles, :title
    add_index :knowledge_pieces, :title
  end

  def down
    remove_index :tags, :name
    remove_index :articles, :title
    remove_index :knowledge_pieces, :title
  end
end
