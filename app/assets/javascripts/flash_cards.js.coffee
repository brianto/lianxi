CARD_TABLET_TEMPLATE =
  _.template '<ul class="list-unstyled"><li><%= character %></li><li><em><%= pronunciation %></em></li></ul>'
EXAMPLE_TABLET_TEMPLATE =
  _.template '<ul class="list-unstyled"><li><%= character %></li><li><em><%= translation %></em></li></ul>'
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
        if not _.has mergedMap, lookupIndex
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

  if not matches
    return [original]

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

      if not _.isEmpty(charSuggestSource) && input.length < charSuggestSource.length
        lookupChar = charSuggestSource.charAt input.length
        suggestion = options.hanziMap[lookupChar]

        if suggestion
          return callbackFn _.map suggestion.hanzi, (nextHanzi) ->
            input + nextHanzi

      if not _.isEmpty(pinyinSuggestSource)
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

localStorageCards = ->
  savedCards = localStorage.getItem 'cards'

  if not savedCards
    return null

  JSON.parse savedCards

lianxi.controller 'FlashCardFormController', ($scope, $shared, $cookies) ->
  $shared.includeScope $scope

  $scope.model =
    cards: localStorageCards() || []
    card: ->
      if _.isEmpty $scope.model.cards
        return null

      $scope.model.cards[$scope.cardIndex]

  # TODO should this really be here?
  $scope.style =
    card:
      picker: (index) ->
        return if $scope.cardIndex == index
          'btn btn-default'
        else
          'btn btn-link'

  $scope.display =
    card:
      character: (card) ->
        card[$cookies.charset] || card.simplified || card.traditional

      pronunciation: (card) ->
        card[$cookies.transcript] || card.pinyin || card.jyutping

      asTablet: (card) ->
        character = $scope.display.card.character card
        pronunciation = $scope.display.card.pronunciation card

        if character || pronunciation
          return CARD_TABLET_TEMPLATE
            character: character
            pronunciation: pronunciation

        EMPTY_TEMPLATE

  $scope.handlers =
    card:
      add: ->
        $scope.model.cards.push
          simplified: ''
          traditional: ''
          pinyin: ''
          jyutping: ''
          part_of_speech: ''
          meaning: ''
          examples: []

        $scope.cardIndex = $scope.model.cards.length - 1

      edit: (index) ->
        $scope.cardIndex = index
        $scope.card = $scope.model.cards[index]

      delete: ->
        index = $scope.cardIndex

        $scope.model.cards.splice index, 1

        while index >= $scope.model.cards.length
          index--

        $scope.cardIndex = index

  $scope.permissions =
    card:
      edit: ->
        $scope.model.card()

      delete: ->
        not _.isEmpty $scope.model.cards

lianxi.controller 'ExampleFormController', ($scope, $shared, $cookies) ->
  $scope.model =
    examples: ->
      card = $shared.model.card()

      return if card
        card.examples
      else
        []

    example: ->
      examples = $scope.model.examples()

      return if _.isEmpty examples
        null
      else
        examples[$scope.exampleIndex]

  $scope.style =
    example:
      picker: (index) ->
        return if $scope.exampleIndex == index
          'btn btn-default'
        else
          'btn btn-link'

  $scope.display =
    example:
      character: (example) ->
        example[$cookies.charset] || example.simplified || example.traditional

      pronunciation: (example) ->
        example[$cookies.transcript] || example.pinyin || example.jyutping

      asTablet: (example) ->
        character = $scope.display.example.character example
        translation = example.translation

        if character || translation
          return EXAMPLE_TABLET_TEMPLATE
            character: character
            translation: translation

        EMPTY_TEMPLATE

  $scope.handlers =
    example:
      add: ->
        $scope.model.examples().push
          simplified: ''
          traditional: ''
          pinyin: ''
          jyutping: ''
          translation: ''

        $scope.exampleIndex = $scope.model.examples().length - 1

      edit: (index) ->
        $scope.exampleIndex = index
        $scope.example = $scope.model.examples()[index]

      delete: ->
        index = $scope.exampleIndex
        examples = $scope.model.examples()

        examples.splice index, 1

        while index >= examples.length
          index--

        $scope.exampleIndex = index

  $scope.permissions =
    example:
      add: ->
        $shared.model.card()

      edit: ->
        $scope.model.example()

      delete: ->
        $scope.model.examples().length > 0

lianxi.controller 'FlashCardSubmitController', ($scope, $shared) ->
  $scope.cards = ->
    $shared.model.cards

  sanitize = (jsonString) ->
    jsonString.replace /,"\$\$hashKey":"[A-Z0-9]{3}"/g, ''

  $scope.$watch ->
    sanitize JSON.stringify $scope.cards()
  , (current, previous) ->
    localStorage.setItem 'cards', current

