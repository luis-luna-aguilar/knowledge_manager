class CreateJoinTableArticlesTags < ActiveRecord::Migration
  def up
    create_table :articles_tags, :id => false do |t|
      t.references :article, :tag
    end

    add_index :articles_tags, [:article_id, :tag_id]
  end

  def down
    remove_index :articles_tags, [:article_id, :tag_id]
    drop_table :articles_tags
  end
end
