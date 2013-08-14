class TagBuilder

  attr_accessor :name_parts

  def initialize(name)
    raise ArgumentError, "Empty tag name" if name.blank?
    @name_parts = name.split(":")
    validate_name_parts!
  end

  def create!
    case @name_parts.count
    when 1
      create_root_tag!
    when 2
      create_tag_referenced_by_parent!
    when 3
      create_tag_referenced_by_ancestor!
    else
      raise ArgumentError, "Tag Name supports a maximum of 3 parts, separated by semicolons"
    end
  end

  private

    def create_root_tag!
      root_name = @name_parts.first
      Tag.create(name: root_name)
    end

    def create_tag_referenced_by_parent!
      parent_name, child_name = @name_parts
      validate_uniqueness_and_existance!(parent_name, :parent)
      parent_tag = Tag.find_by_name(parent_name)
      parent_tag.children.create(name: child_name)
    end

    def create_tag_referenced_by_ancestor!
      ascendant_name, parent_name, child_name = @name_parts
      validate_uniqueness_and_existance!(ascendant_name, :ancestor)
      ascendant_tag = Tag.find_by_name(ascendant_name)
      validate_child_existance!(parent_name, ascendant_tag)
      parent_tag = ascendant_tag.children.find_by_name(parent_name)
      parent_tag.children.create(name: child_name)
    end

    def validate_name_parts!
      raise ArgumentError, "Tag name has no parts" if @name_parts.empty?
      @name_parts.each do |name_part|
        raise ArgumentError, "Tag name is empty in one of its parts" if name_part.blank?
      end
    end

    def validate_child_existance!(name, parent)
      unless parent.children.exists?(name: name)
        raise "Child does not exist for parent: #{parent.name}"
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