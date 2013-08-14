$ ->

  $("textarea.codeable").on 'keydown', (evt) ->
    if evt.ctrlKey && evt.keyCode == 67
      $(this).val(($(this).val() + "<code></code>"))
      set_cursor_inside_code_tags("inline", $(this))
      return false
    if evt.ctrlKey && evt.keyCode == 80
      $(this).val(($(this).val() + "<code>\n\n</code>"))
      set_cursor_inside_code_tags("multiline", $(this))
      return false

  set_cursor_inside_code_tags = (code_tag_type, element) ->
    if code_tag_type == "inline"
      $cursor_position = (element.val().length - 7)
    if code_tag_type == "multiline"
      $cursor_position = (element.val().length - 8)

    element[0].selectionStart = $cursor_position
    element[0].selectionEnd = $cursor_position
