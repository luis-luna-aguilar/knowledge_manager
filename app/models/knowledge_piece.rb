class KnowledgePiece < ActiveRecord::Base
  belongs_to :article
  has_and_belongs_to_many :tags
  
  attr_accessible :body, :title, :tags_list

  def tags_list
  end

  def tags_list=  
  end

end
