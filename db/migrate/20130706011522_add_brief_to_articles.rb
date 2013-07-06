class AddBriefToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :brief, :text
  end
end
