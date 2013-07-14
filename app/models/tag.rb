class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :articles
  has_and_belongs_to_many :knowledge_pieces

  attr_accessible :name
  validates_presence_of :name
  
  has_ancestry

  def unique_name
    if is_root?
      name
    elsif Tag.is_unique_name?(parent.name)
      "#{parent.name}:#{name}"
    else
      "#{unique_ancestor.name}:#{parent.name}:#{name}"
    end
  end

  def unique_ancestor
    ancestors.reverse_each do |ancestor|
      if Tag.is_unique_name?(ancestor.name)
        return ancestor
      end
    end

    nil
  end

  def name=(name)
    if self.new_record?
      create_name(name)
    else
      update_name(name)
    end
  end

  private

  def self.is_unique_name?(name)
    where(name: name).count == 1
  end

  def update_name(name)
    raise ArgumentError, "Empty name" if name.blank?
    return name if self.name == name
    raise ArgumentError, "There is a sibling with the same name" if self.siblings.exists?(name: name)
    write_attribute(:name, name)
  end

  def create_name(name)
    raise ArgumentError, "Empty name" if name.blank?
    
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

  def create_root_tag(name_structure)
    root_name = name_structure[0]
    validate_root!(root_name)

    write_attribute(:name, root_name)
  end

  def create_tag_referenced_by_parent(name_structure)
    parent_name, child_name = name_structure
    validate_uniqueness_and_existance!(parent_name, :parent)
    parent_tag = Tag.find_by_name(parent_name)
    validate_child!(child_name, parent_tag, :parent)

    write_attribute(:name, child_name)
    self.parent = parent_tag
  end

  def create_tag_referenced_by_ancestor(name_structure)
    ascendant_name, parent_name, child_name = name_structure
    validate_uniqueness_and_existance!(ascendant_name, :ancestor)
    ascendant_tag = Tag.find_by_name(ascendant_name)
    validate_child!(parent_name, ascendant_tag, :ancestor)
    parent_tag = ascendant_tag.children.find_by_name(parent_name)
    validate_child!(child_name, parent_tag, :parent)
    
    write_attribute(:name, child_name)
    self.parent = parent_tag
  end

  def validate_root!(tag_name)
    if Tag.roots.exists?(name: tag_name)
      raise ArgumentError, "Root tag already exists"
    end
  end

  def validate_uniqueness_and_existance!(name, element_type)
    tag = Tag.where(name: name)
    
    if tag.count > 1
      trigger_errors_for_validate_uniqueness_and_existance_when_is_not_unique(element_type)
    elsif tag.blank?
      trigger_errors_for_validate_uniqueness_and_existance_when_does_not_exist(element_type)
    end
  end

  def validate_child!(name, parent, parent_type)
    if parent.children.exists?(name: name) && parent_type != :ancestor
      case parent_type
      when :parent
        raise ArgumentError, "New tag name already exists"
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

  def trigger_errors_for_validate_uniqueness_and_existance_when_is_not_unique(element_type)
    case element_type
    when :parent
      raise ArgumentError, "Parent name is not unique, it has to be a unique tag name"
    when :ancestor
      raise ArgumentError, "Ancestor name is not unique, it has to be a unique tag name"
    else
      raise ArgumentError, "Element Type is undefined when calling validate_uniqueness! method"
    end
  end

  def trigger_errors_for_validate_uniqueness_and_existance_when_does_not_exist(element_type)
    case element_type
    when :parent
      raise ArgumentError, "Parent name does not exists"
    when :ancestor
      raise ArgumentError, "Ancestor name does not exists"
    else
      raise ArgumentError, "Element Type is undefined when calling validate_uniqueness! method"
    end
  end

end
