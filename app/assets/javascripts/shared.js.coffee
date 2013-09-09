window.add_redactor = (element) ->
  element.redactor
    minHeight: 200
    buttonsAdd: ['|', 'insert_code']
    buttonsCustom:
      insert_code:
        title: 'Code Box'
        callback: (buttonName, buttonDOM, buttonObject) ->
          $time_stamp = (new Date().getTime())
          @bufferSet()
          @insertHtml("<code id='#{$time_stamp}' style='display: block'>code...</code><br>")
          @setCaret($("code##{$time_stamp}"), 0)

$ ->

  add_redactor $('.redactor-component')
