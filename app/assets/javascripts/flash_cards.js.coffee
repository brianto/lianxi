PICKER_TEMPLATE = _.template '<ul class="list-unstyled"><li><%= character %></li><li><em><%= pronunciation %></em></li></ul>'
EMPTY_TEMPLATE = '<em>new</em>' 
ACCENT_MAP = _.reduce
  a: ['ā', 'á', 'à', 'ǎ', 'a']
  e: ['ē', 'é', 'è', 'ě', 'e']
  i: ['ī', 'í', 'ì', 'ǐ', 'i']
  o: ['ī', 'í', 'ì', 'ǐ', 'i']
  u: ['ū', 'ú', 'ù', 'ǔ', 'u']
, (map, variants) ->
  _.each variants, (variant) ->
    map[variant] = variants

  return map
, {}
ACCENTS_REGEX  = new RegExp '[' + _.keys(ACCENT_MAP).join('') + ']', 'gi'

explodeMap = (mappings) ->
  _.reduce mappings, (mergedMap, mapping) ->
    mappingKeys = _.keys mapping

    _.each mappingKeys, (key) ->
      _.each mapping[key], (lookupIndex) ->
        if !_.has mergedMap, lookupIndex
          mergedMap[lookupIndex] =
            hanzi: []
            pinyin: []

        _.each mappingKeys, (k) ->
          mergedMap[lookupIndex][k] =
            _.union mergedMap[lookupIndex][k], mapping[k]

    return mergedMap
  , {}

accentedChoices = (original) ->
  matches = original.match ACCENTS_REGEX

  return [] if not matches

  vowel = _.last matches

  _.map ACCENT_MAP[vowel], (accentedVowel) ->
    return original.replace vowel, accentedVowel

$(document).ready ->
  inputs =
    simplified: $ '#card-simplified'
    traditional: $ '#card-traditional'
    pinyin: $ '#card-pinyin'

  characterSuggestFn = (options) ->
    (request, callbackFn) ->
      input = request.term
      charSuggestSource = options.characterSuggestSource.val()
      pinyinSuggestSource = options.pinyinSuggestSource.val()

      if !_.isEmpty(charSuggestSource) && input.length < charSuggestSource.length
        lookupChar = charSuggestSource.charAt input.length
        suggestion = options.hanziMap[lookupChar]

        if suggestion
          return callbackFn _.map suggestion.hanzi, (nextHanzi) ->
            input + nextHanzi

      if !_.isEmpty(pinyinSuggestSource)
        pinyin = pinyinSuggestSource.split /\s+/

        if input.length < pinyin.length
          lookupPinyin = pinyin[input.length]

          suggestions = _.reduce accentedChoices(lookupPinyin), (allSuggestions, inferredPinyin) ->
            suggestion = options.hanziMap[inferredPinyin]

            # TODO extract to merge function?
            if suggestion
              allSuggestions.hanzi = _.union allSuggestions.hanzi, suggestion.hanzi
              allSuggestions.pinyin = _.union allSuggestions.pinyin, suggestion.pinyin

            allSuggestions
          , { hanzi: [], pinyin: [] }

          return callbackFn _.map suggestions.hanzi, (nextHanzi) ->
            input + nextHanzi

  $.ajax
    url: STATIC.urls.hanziMap
  .done (response) ->
    HANZI_MAP = explodeMap response

    inputs.simplified.on 'keyup', (event) ->
      if event.keyCode == 16
        inputs.simplified.autocomplete 'search', inputs.simplified.val()
    inputs.simplified.autocomplete
      delay: 0
      minLength: 0
      close: (event, ui) ->
        $(event.target).trigger 'input'
      source: characterSuggestFn
        hanziMap: HANZI_MAP
        characterSuggestSource: inputs.traditional
        pinyinSuggestSource: inputs.pinyin

    inputs.traditional.autocomplete
      delay: 0
      minLength: 0
      close: (event, ui) ->
        $(event.target).trigger 'input'
      source: characterSuggestFn
        hanziMap: HANZI_MAP
        characterSuggestSource: inputs.simplified
        pinyinSuggestSource: inputs.pinyin

    # TODO make suggest function smarter
    inputs.pinyin.autocomplete
      delay: 0
      minLength: 0
      source: _.chain(HANZI_MAP).keys().filter (key) ->
        key.match /[a-z]/i
      .value()

lianxi.controller 'NewDrillController', ($scope, $cookies) ->
  $scope.cards = []

  $scope.model =
    card: ->
      if _.isEmpty $scope.cards
        return null

      $scope.cards[$scope.cardIndex]

    character: (card) ->
      card[$cookies.charset] || card.simplified || card.traditional

    pronunciation: (card) ->
      card[$cookies.transcript] || card.pinyin || card.jyutping

  # TODO should this really be here?
  $scope.style =
    picker: (index) ->
      return if $scope.cardIndex == index
        'btn btn-default'
      else
        'btn btn-link'

  $scope.display =
    card: (card) ->
      character = $scope.model.character card
      pronunciation = $scope.model.pronunciation card

      if character || pronunciation
        return PICKER_TEMPLATE
          character: character
          pronunciation: pronunciation

      EMPTY_TEMPLATE

  $scope.handlers =
    card:
      add: ->
        $scope.cards.push
          simplified: ''
          traditional: ''
          pinyin: ''
          jyutping: ''
          part_of_speech: ''
          meaning: ''
          examples: []

        $scope.cardIndex = $scope.cards.length - 1

      edit: (index) ->
        $scope.cardIndex = index
        $scope.card = $scope.cards[index]

      delete: ->
        index = $scope.cardIndex

        $scope.cards.splice index, 1

        while index >= $scope.cards.length
          index--

        $scope.cardIndex = index

  $scope.permissions =
    card:
      edit: ->
        not _.isNull $scope.model.card()

      delete: ->
        not _.isEmpty $scope.cards
