$ ->

  $("#references_fields").nestedFields
    itemSelector: ".references-item"
    containerSelector: ".references-items"
    addSelector: ".references-add"
    removeSelector: ".references-remove"

  $("#knowledge_pieces_fields").nestedFields
    afterInsert: (item) ->
      add_redactor item.find("textarea")
