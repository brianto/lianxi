PICKER_TEMPLATE = _.template '<ul class="list-unstyled"><li><%= character %></li><li><em><%= pronunciation %></em></li></ul>'
EMPTY_TEMPLATE = '<em>new</em>' 
ACCENT_MAP = _.reduce
  a: ['ā', 'á', 'ǎ', 'à', 'a']
  e: ['ē', 'é', 'ě', 'è', 'e']
  i: ['ī', 'í', 'ǐ', 'ì', 'i']
  o: ['ō', 'ó', 'ǒ', 'ò', 'o']
  u: ['ū', 'ú', 'ǔ', 'ù', 'u']
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

  return [original] if not matches

  _.chain(matches)
  .map (vowel) ->
    _.map ACCENT_MAP[vowel], (accentedVowel) ->
      original.replace vowel, accentedVowel
  .flatten()
  .value()

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
    VALID_PINYIN = _.chain(HANZI_MAP)
    .keys()
    .filter (key) ->
      key.match /[a-z]/i
    .value()

    triggerSearchFn = (event) ->
      if event.keyCode == 16
        $(this).autocomplete 'search', $(this).val()

    inputs.simplified.on 'keyup', triggerSearchFn
    inputs.simplified.autocomplete
      delay: 0
      minLength: 0
      close: (event, ui) ->
        $(event.target).trigger 'input'
      source: characterSuggestFn
        hanziMap: HANZI_MAP
        characterSuggestSource: inputs.traditional
        pinyinSuggestSource: inputs.pinyin

    inputs.traditional.on 'keyup', triggerSearchFn
    inputs.traditional.autocomplete
      delay: 0
      minLength: 0
      close: (event, ui) ->
        $(event.target).trigger 'input'
      source: characterSuggestFn
        hanziMap: HANZI_MAP
        characterSuggestSource: inputs.simplified
        pinyinSuggestSource: inputs.pinyin

    inputs.pinyin.on 'keyup', triggerSearchFn
    inputs.pinyin.autocomplete
      delay: 0
      minLength: 0
      source: (request, callbackFn) ->
        inputs = request.term.trim().split /\s+/
        workingInput = _.last inputs

        if workingInput.length < 1
          return callbackFn []

        inferredInputs = accentedChoices workingInput
        suggestionRegex = new RegExp '^(' + inferredInputs.join('|') + ')'
        suggestions = _.chain(VALID_PINYIN)
        .filter (pinyin) ->
          pinyin.match suggestionRegex
        .map (pinyin) ->
          suggestion = _.clone inputs
          suggestion[suggestion.length - 1] = pinyin
          suggestion.join ' '
        .value()

        callbackFn suggestions

lianxi.controller 'FlashCardFormController', ($scope, $cookies) ->
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
