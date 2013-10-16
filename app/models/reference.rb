class Reference < ActiveRecord::Base

  attr_accessible :url
  validates_presence_of :url
  belongs_to :referenceable, polymorphic: true
  
end
