class Article < ActiveRecord::Base
  
  include ActAsTaggable
  has_and_belongs_to_many :tags
  has_many :knowledge_pieces, dependent: :destroy

  attr_accessible :reference_url, :title, :brief, :tags_list, :knowledge_pieces_attributes
  validates_presence_of :reference_url, :title, :brief

  accepts_nested_attributes_for :knowledge_pieces, allow_destroy: true

  after_save :link_tags_to_related_knowledge_pieces

  private

    def link_tags_to_related_knowledge_pieces
      knowledge_pieces.each do |kp|
        self.tags.each {|tag| kp.tags << tag unless kp.tags.include?(tag)}
      end
    end
  
end