class RemoveReferenceUrlFromArticles < ActiveRecord::Migration
  
  def up
    remove_column :articles, :reference_url
  end

  def down
    add_column :articles, :reference_url, :string
  end

end
