class KnowledgePiece < ActiveRecord::Base
  
  include ActAsTaggable
  has_and_belongs_to_many :tags
  belongs_to :article
  
  attr_accessible :body, :title, :tags_list
  validates_presence_of :body, :title
  
end