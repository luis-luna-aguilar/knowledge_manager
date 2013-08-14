class Article < ActiveRecord::Base
  
  include ActAsTaggable
  has_and_belongs_to_many :tags
  has_many :knowledge_pieces

  attr_accessible :reference_url, :title, :brief, :knowledge_pieces_attributes
  validates_presence_of :reference_url, :title, :brief

  accepts_nested_attributes_for :knowledge_pieces, allow_destroy: true
  
end