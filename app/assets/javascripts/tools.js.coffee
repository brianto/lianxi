$(document).ready ->
  container = $("#tools")

  return unless container.length

  frame = container.find "iframe"

  urls =
    google: "http://translate.google.com/m/translate"
    wiktionary: "http://en.m.wiktionary.org"
    cantodict: "http://www.cantonese.sheik.co.uk/dictionary/"
    toshuo: "http://toshuo.com/chinese-tools/pinyin-to-zhuyin-live-converter"

  container.find("li a").on "click", (event) ->
    # Set up frame src
    tool = $(this).attr "class"
    frame.attr "src", urls[tool]

    # Adjust tab classes to reflect clicked
    $(this).parent("li").siblings().removeClass "active"
    $(this).parent("li").addClass "active"

  # Initial tool
  container.find("li a").first().trigger "click"
