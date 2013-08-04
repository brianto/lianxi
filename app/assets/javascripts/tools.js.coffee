$(document).ready ->
  container = $("#tools")

  return unless container.length

  frame = container.find "iframe"

  container.find("li a").on "click", (event) ->
    # Figure out which iframe is desired
    tool = $(this).attr "class"

    # Adjust iframes to reflect chosen tab
    container.find("iframe").hide()
    container.find("iframe.#{tool}").show()

    # Adjust tab classes to reflect clicked
    $(this).parent("li").siblings().removeClass "active"
    $(this).parent("li").addClass "active"

  # Initial tool
  container.find("li a").first().trigger "click"
