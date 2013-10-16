class Article < ActiveRecord::Base
  
  include ActAsTaggable
  has_and_belongs_to_many :tags
  has_many :knowledge_pieces, dependent: :destroy
  has_many :references, as: :referenceable, dependent: :destroy

  attr_accessible :title, :brief, :tags_list, :knowledge_pieces_attributes, :references_attributes
  validates_presence_of :title, :brief

  accepts_nested_attributes_for :knowledge_pieces, allow_destroy: true
  accepts_nested_attributes_for :references, allow_destroy: true

  after_save :link_tags_to_related_knowledge_pieces

  validate :references_count
  
  def references_count
    if references.empty?
      errors.add(:references, "There should be at least one reference for this article")
    end
  end

  private

    def link_tags_to_related_knowledge_pieces
      knowledge_pieces.each do |kp|
        self.tags.each {|tag| kp.tags << tag unless kp.tags.include?(tag)}
      end
    end
  
end
