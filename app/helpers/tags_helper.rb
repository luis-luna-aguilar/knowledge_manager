module TagsHelper

  def generate_tag_links(tags_list)
    html = ''
    tags_list.each do |tag|
      html << (link_to tag.name, tag_path(tag))
      html << ',&nbsp;'
    end
    html.chomp(",&nbsp;").html_safe
  end

end