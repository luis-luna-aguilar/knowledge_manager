class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles
  has_and_belongs_to_many :knowledge_pieces

  attr_accessible :name
  has_ancestry
end
