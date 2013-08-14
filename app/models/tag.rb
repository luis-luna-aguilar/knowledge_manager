class Tag < ActiveRecord::Base

  has_ancestry
  has_and_belongs_to_many :articles
  has_and_belongs_to_many :knowledge_pieces

  attr_accessible :name
  validates_presence_of :name
  validate :is_unique_name_at_the_same_tree_level
  

  def unique_name
    if is_root?
      name
    elsif Tag.is_existent_unique_name?(parent.name)
      "#{parent.name}:#{name}"
    else
      "#{closest_unique_ancestor.name}:#{parent.name}:#{name}"
    end
  end

  def closest_unique_ancestor
    ancestors.reverse_each do |ancestor|
      if Tag.is_existent_unique_name?(ancestor.name)
        return ancestor
      end
    end

    raise "There is no unique ancestor for: #{name}"
  end

  def self.find_by_unique_name(name)
    node_name = name.split(":").last
    (where(name: node_name).all.select {|tag| tag.unique_name == name}).first
  end

  private

    def self.is_existent_unique_name?(name)
      where(name: name).count == 1
    end

    def self.count_by_name(name)
      where(name: name).count
    end

    def is_unique_name_at_the_same_tree_level
      exists_tag_with_same_name = siblings.exists?(name: name)
      
      if exists_tag_with_same_name && (new_record? || is_name_changing?)
        errors.add(:siblings, "There is a sibling with the same name")
      end
    end

    def is_name_changing?
      (Tag.find(self.id).name != self.name)
    end

end