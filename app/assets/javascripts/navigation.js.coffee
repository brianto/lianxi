CHARSETS =
  simplified: "Simplified"
  traditional: "Traditional"

TRANSCRIPTS =
  pinyin: "Pinyin"
  jyutping: "Jyutping"

cyclicSelector = (store, choices, key) ->
  keys = _.keys choices

  return ->
    position = _.indexOf keys, store[key]
    next = (position + 1) % keys.length
    store[key] = keys[next]

sanitizePreferences = (store, choices, key) ->
  keys = _.keys choices

  if not _.contains keys, store[key]
    store[key] = _.chain(choices).keys().first().value()

window.lianxi.controller 'NavigationController', ($scope) ->
  sanitizePreferences localStorage, CHARSETS, 'charset'
  sanitizePreferences localStorage, TRANSCRIPTS, 'transcript'

  $scope.handlers =
    charset: cyclicSelector localStorage, CHARSETS, 'charset'
    transcript: cyclicSelector localStorage, TRANSCRIPTS, 'transcript'

  $scope.display =
    charset: -> CHARSETS[localStorage.charset]
    transcript: -> TRANSCRIPTS[localStorage.transcript]
