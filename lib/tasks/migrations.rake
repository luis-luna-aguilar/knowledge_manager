require 'rubygems'

namespace :migrations do

  desc "Description"
  task :move_articles_reference_urls => :environment do
    Article.all.each do |article|
      url = article.reference_url
      article.references << Reference.create(url: url)
      article.save
    end
  end

end
