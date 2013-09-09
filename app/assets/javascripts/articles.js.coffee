$ ->

  $("form.new_article, form.edit_article").nestedFields
    afterInsert: (item) ->
      add_redactor item.find("textarea")
