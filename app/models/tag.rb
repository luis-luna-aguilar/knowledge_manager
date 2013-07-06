class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :articles
  has_and_belongs_to_many :knowledge_pieces

  attr_accessible :name
  validates_presence_of :name
  has_ancestry

  def name=(name)
    name_structure = name.split(":")
    validate_name_structure!(name_structure)
    
    case name_structure.count
    when 1
      create_root_tag(name_structure)
    when 2
      create_tag_referenced_by_parent(name_structure)
    when 3
      create_tag_referenced_by_ancestor(name_structure)
    else
      raise ArgumentError, "Tag Name supports a maximum of 3 parts, separated by semicolons"
    end
  end

  private

  def create_root_tag
    root_name = name_structure[0]
    validate_root!(root_name)
    create(name: root_name)
  end

  def create_tag_referenced_by_parent
    parent_name, child_name = name_structure
    validate_uniqueness_and_existance!(parent_name, :parent)
    parent_tag = Tag.find_by_name(parent_name)
    validate_child!(child_name, parent, :parent)
    parent_tag.children.create(name: child_name)
  end

  def create_tag_referenced_by_ancestor
    ascendant_name, parent_name, child_name = name_structure
    validate_uniqueness_and_existance!(ascendant_name, :ancestor)
    ascendant_tag = Tag.find_by_name(ascendant_name)
    validate_child!(parent_name, ascendant_tag, :ancestor)
    parent_tag = ascendant_tag.children.find_by_name(parent_name)
    validate_child!(child_name, parent_tag, :parent)
    parent_tag.children.create(name: child_name)
  end

  def validate_root!(name)
    if roots.exists?(name: name)
      raise ArgumentError, "Root tag already exists"
    end
  end

  def validate_uniqueness_and_existance!(name, element_type)
    tag = Tag.where(name: name)
    if tag.present? && tag.count > 2
      case element_type
      when :parent
        raise ArgumentError, "Parent name is not unique, it has to be a unique tag name"
      when :ancestor
        raise ArgumentError, "Ancestor name is not unique, it has to be a unique tag name"
      else
        raise ArgumentError, "Element Type is undefined when calling validate_uniqueness! method"
      end
    end
  end

  def validate_child!(name, parent, parent_type)
    if parent.children.exists?(name: name)
      case parent_type
      when :parent
        raise ArgumentError, "Tag name already exists"
      when :ancestor
        raise ArgumentError, "Parent name already exists, it has to be a unique tag name"
      else
        raise ArgumentError, "Parent Type is undefined when calling validate_child! method"
      end
    end
  end

  def validate_name_structure!(name_structure)
    name_structure.each do |name|
      if name.blank?
        raise ArgumentError, "Tag name is empty in one of its parts"
      end
    end
  end

end
