class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :reference_url

      t.timestamps
    end
  end
end
