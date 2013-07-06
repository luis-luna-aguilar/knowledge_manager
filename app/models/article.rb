class Article < ActiveRecord::Base
  has_many :knowledge_pieces
  has_and_belongs_to_many :tags

  attr_accessible :reference_url, :title, :brief
  validates_presence_of :reference_url, :title, :brief
end
