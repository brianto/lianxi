index = 0
cards = null

CHARSET = ["simplified", "traditional"]
TRANSCRIPT = ["pinyin", "zhuyin", "jyutping"]

cleanPreferences = (choices, key, fallback) ->
  pref = $.cookie key

  if _.contains choices, pref
    return pref

  return fallback

importSettings = ->
  settings =
    character: $.cookie("character-enabled")
    pronunciation: $.cookie("pronunciation-enabled")
    partOfSpeech: $.cookie("part-of-speech-enabled")
    meaning: $.cookie("meaning-enabled")

  _.each settings, (setting, key) ->
    if _.isNull setting
      settings[key] = true
    else
      settings[key] = setting == "true"

  return settings

exportSettings = (settings) ->
  $.cookie "character-enabled", String(settings.character)
  $.cookie "pronunciation-enabled", String(settings.pronunciation)
  $.cookie "part-of-speech-enabled", String(settings.partOfSpeech)
  $.cookie "meaning-enabled", String(settings.meaning)

$(document).ready ->
  # Only apply for quiz actions
  return unless $("body.quiz").length

  preferences =
    charset: cleanPreferences CHARSET, "charset", "simplified"
    transcript: cleanPreferences TRANSCRIPT, "transcript", "pinyin"

  settings = importSettings()

  controls =
    settings:
      pronunciation: $("#settings #pronunciation-enabled")
      character: $("#settings #character-enabled")
      partOfSpeech: $("#settings #part-of-speech-enabled")
      meaning: $("#settings #meaning-enabled")

    flashCard:
      pronunciation: $("#flash-card #pronunciation")
      character: $("#flash-card #character")
      partOfSpeech: $("#flash-card #part-of-speech")
      meaning: $("#flash-card #meaning")

    actions:
      know: $("#actions #know")
      goBack: $("#actions #go-back")
      goForward: $("#actions #go-forward")
      dontKnow: $("#actions #dont-know")

  # Refreshes setting controls' state based on current values
  refreshControls = ->
    s = controls.settings

    s.pronunciation.toggleClass "active", settings.pronunciation
    s.character.toggleClass "active", settings.character
    s.partOfSpeech.toggleClass "active", settings.partOfSpeech
    s.meaning.toggleClass "active", settings.meaning

  # Refreshes flash card div based on current card and preferences
  refreshFlashCard = ->
    card = cards[index]
    fc = controls.flashCard

    fc.pronunciation.text card[preferences.transcript]
    fc.character.text card[preferences.charset]
    fc.partOfSpeech.text card["part_of_speech"]
    fc.meaning.text card.meaning

    _.each fc, (display) ->
      display.css "visibility", "hidden"

    if settings.pronunciation
      fc.pronunciation.css "visibility", "visible"

    if settings.character
      fc.character.css "visibility", "visible"

    if settings.partOfSpeech
      fc.partOfSpeech.css "visibility", "visible"

    if settings.meaning
      fc.meaning.css "visibility", "visible"

  # Adjusts settings value based on controls, saves, and refreshes flash card
  changePreferences = (setting) ->
    _.defer (event) =>
      settings[setting] = $(this).hasClass("active")
      exportSettings(settings)
      refreshFlashCard()

  ### Listeners ###
  controls.settings.character.on "click",
    _.partial(changePreferences, "character")

  controls.settings.pronunciation.on "click",
    _.partial(changePreferences, "pronunciation")

  controls.settings.partOfSpeech.on "click",
    _.partial(changePreferences, "partOfSpeech")

  controls.settings.meaning.on "click",
    _.partial(changePreferences, "meaning")

  controls.actions.goForward.on "click", ->
    index = (index + 1) % cards.length
    refreshFlashCard()

  controls.actions.goBack.on "click", ->
    index = (index + cards.length - 1) % cards.length
    refreshFlashCard()

  # TODO handlers for know and don't know

  $.ajax
    url: window.location.pathname.replace "quiz", "flash_cards.json"
    success: (response, status, jqXHR) ->
      if response.length
        cards = _.shuffle response
        refreshControls()
        refreshFlashCard()
