class CyclicSelector
  constructor: (choices) ->
    @choices = choices
    @keys = _.keys(choices)
    @index = 0

  current: =>
    data: @keys[@index]
    text: @choices[@keys[@index]]

  next: =>
    @index = (@index + 1) % _.size(@choices)
    @current()

  to: (key) =>
    if !_.contains(@keys, key)
      throw "Could not find #{key} in #{@keys}"

    @index = _.indexOf(@keys, key)
    @current()

$(document).ready ->
  charset = new CyclicSelector
    simplified: "Simplified"
    traditional: "Traditional"

  transcript = new CyclicSelector
    pinyin: "Pinyin"
    zhuyin: "Zhuyin"
    jyutping: "Jyutping"

  preferences_handler_for = (selector, key, cycle) ->
    $(selector).on "click", (event) ->
      next = cycle.next()

      $(this).val(next.data)
      $(this).text(next.text)

      $.cookie(key, next.data)

  preferences_default_for = (selector, key, cycle, fallback) ->
    selector_default = $.cookie(key) || fallback

    cycle.to selector_default

    current = cycle.current()

    $(selector).val(current.data)
    $(selector).text(current.text)

  preferences_for = (selector, key, cycle, fallback) ->
    preferences_default_for selector, key, cycle, fallback
    preferences_handler_for selector, key, cycle

  preferences_for "#pref-charset",
    "charset", charset, "simplified"

  preferences_for "#pref-transcript",
    "transcript", transcript, "pinyin"
