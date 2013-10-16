insert_code_snippet = (e) ->
  $time_stamp = (new Date().getTime())
  e.bufferSet()
  e.insertHtml("<p><code class='#{$time_stamp}' style='display: block'></code></p><br/>")
  e.setCaret($("code.#{$time_stamp}"), 0)

strip_html = (html) ->
  jQuery(html).text().replace(" ", "&nbsp;")

is_inside_code_box = (redactor) ->
  current_node = redactor.getCurrent()
  current_node.nodeName == "CODE" || $(current_node).parents("code").length != 0

window.add_redactor = (element) ->
  element.redactor
    minHeight: 200
    keyupCallback: (e) ->
      if e.ctrlKey && e.keyCode == 67 # ASCII for C
        insert_code_snippet(this)
      if is_inside_code_box(this) && e.keyCode == 13 # ASCII for Carrier Return
        $new_code_box = $(this.getCurrent())
        $original_code_box = $new_code_box.prev()
        $new_code_box.remove()
        $original_code_box.append("<br/>...")
        $last_position = ($original_code_box.text().length)
        this.setCaret($original_code_box, ($last_position - 3))
        e.preventDefault()
    pasteAfterCallback: (html) ->
      if is_inside_code_box(this)
        html = strip_html(html)
      else
        html

$ ->

  add_redactor $('.redactor-component')
