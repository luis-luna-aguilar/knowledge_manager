module ActAsTaggable

  def tags_list
    list = self.tags.inject(""){|list, tag| list + "#{tag.name},"}
    list.chomp(",")
  end

  def tags_list=(list)
    tag_names = list.split(",")
    validate_tag_names!(tag_names)
    
    self.tags = []
    tag_names.each do |tag_name|
      add_tag(tag_name)
    end
  end

  private

    def validate_tag_names!(tag_names)
      raise ArgumentError, "Tag name is blank" if tag_names.empty?
      tag_names.each do |name|
        if name.blank?
          raise ArgumentError, "Tag name is empty"
        end
      end
    end

    def add_tag(tag_name)
      existent_tag = Tag.find_by_unique_name(tag_name)
      if existent_tag.present?
        self.tags << existent_tag
      else
        self.tags << TagBuilder.new(tag_name).create!
      end
    end

end