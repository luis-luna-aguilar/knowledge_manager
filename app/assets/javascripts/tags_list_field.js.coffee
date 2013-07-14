$ ->
	
  $("#tags_list_field").tagit
    singleField: true
    singleFieldDelimiter: ","
    singleFieldNode: $("#knowledge_piece_tags_list").get(0)
    autocomplete: {delay: 0, minLength: 2, source: "/tags_unique_names"}
