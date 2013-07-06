class KnowledgePiece < ActiveRecord::Base
  belongs_to :article
  has_and_belongs_to_many :tags
  
  attr_accessible :body, :title, :tags_list
  validates_presence_of :body, :title, :tags_list

  def tags_list
    list = tags.inject(""){|list, name| list + "name,"}
    list[0..-1]
  end

  def tags_list=(list)
    tag_names = list.split(",")
    validate_tag_names!(tag_names)
  end

  private

  def validate_tag_names!(tag_names)
    tag_names.each do |name|
      if name.blank?
        raise ArgumentError, "Tag name is empty"
      end
    end
  end

end
