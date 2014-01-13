lianxi.controller 'QuizController', ($scope, $cookies) ->
  configuring = false
  revealing = false
  cardIndex = 0
  exampleIndex = 0

  $scope.model =
    cards: []
    card: ->
      cards = $scope.model.cards

      return if _.isEmpty $scope.model.cards
        null 
      else
        $scope.model.cards[cardIndex]

    examples: ->
      card = $scope.model.card()

      return if not card
        []
      else
        card.examples

    example: ->
      examples = $scope.model.examples()

      return if _.isEmpty examples
        null
      else
        examples[exampleIndex]

    difficulties: []
    difficulty: ->
      card = $scope.model.card()

      return if not card
        null
      else
        difficulty = $scope.model.difficulties[card.id]
        difficulty && difficulty.difficulty

    quiz: if $cookies.quiz
        JSON.parse $cookies.quiz
      else
        selection: 'all'
        visible:
          card:
            characters: true
            pronunciation: true
            partOfSpeech: true
            meaning: true
          example:
            characters: true
            translation: true

  $scope.show =
    simplified: -> $cookies.charset == 'simplified'
    traditional: -> $cookies.charset == 'traditional'
    pinyin: -> $cookies.transcript == 'pinyin'
    jyutping: -> $cookies.transcript == 'jyutping'

    configuring: -> configuring
    displaying: -> not configuring
    example:
      container: ->
        not _.isEmpty $scope.model.examples()

  $scope.style =
    _difficultyButton: (difficulty, matchStyle, defaultStyle) ->
      return if $scope.model.difficulty() == difficulty
        matchStyle
      else
        defaultStyle

    difficulty:
      easy: -> $scope.style._difficultyButton 'easy', 'btn-success', 'btn-default'
      hard: -> $scope.style._difficultyButton 'hard', 'btn-danger', 'btn-default'

    _quizStyleBlur: (type, key) ->
      quizVisible = $scope.model.quiz.visible

      return if not quizVisible[type][key] && not revealing
        'quiz-blur'

    card:
      pronunciation: -> $scope.style._quizStyleBlur('card', 'pronunciation')
      characters: -> $scope.style._quizStyleBlur('card', 'characters')
      partOfSpeech: -> $scope.style._quizStyleBlur('card', 'partOfSpeech')
      meaning: -> $scope.style._quizStyleBlur('card', 'meaning')

    example:
      characters: -> $scope.style._quizStyleBlur('example', 'characters')
      translation: -> $scope.style._quizStyleBlur('example', 'translation')

  $scope.handlers =
    card:
      next: ->
        revealing = false
        exampleIndex = 0
        cardIndex++
      previous: ->
        revealing = false
        exampleIndex = 0
        cardIndex--

    example:
      next: -> exampleIndex++
      previous: -> exampleIndex--

    difficulty:
      _update: (difficulty) ->
        card = $scope.model.card()
        cardId = card.id.toString()
        difficulties = $scope.model.difficulties

        if not _.has difficulties, cardId
          difficulties[cardId] =
            flash_card_id: cardId
            difficulty: ''

        difficultyRef = difficulties[cardId]
        currentDifficulty = difficultyRef.difficulty

        difficultyRef.difficulty = if currentDifficulty == difficulty
          ''
        else
          difficulty

      easy: -> $scope.handlers.difficulty._update 'easy'
      hard: -> $scope.handlers.difficulty._update 'hard'

    quiz:
      reveal: ->
        revealing = not revealing
      configure: ->
        configuring = not configuring

  $scope.permissions =
    action: ->
      not configuring
    card:
      next: ->
        return if _.isEmpty $scope.model.cards
          false
        else
          cardIndex < $scope.model.cards.length - 1
      previous: ->
        return if _.isEmpty $scope.model.cards
          false
        else
          0 < cardIndex

    example:
      next: ->
        examples = $scope.model.examples()

        return if _.isEmpty examples
          false
        else
          exampleIndex < examples.length - 1
      previous: ->
        return if _.isEmpty $scope.model.examples()
          false
        else
          0 < exampleIndex


  $scope.$watch ->
    JSON.stringify $scope.model.quiz
  , (current, previous) ->
    $cookies.quiz = current

  $.ajax
    url: globals.jsonUrl
  .done (response) ->
    cards = response.cards

    if not _.isEmpty cards
      $scope.$apply ->
        $scope.model.cards = response.cards
        cardIndex = 0
        exampleIndex = 0
      
  .fail (jqXHR, status, error) ->
    debugger

  $.ajax
    url: globals.difficultiesUrl
  .done (response) ->
    $scope.$apply ->
      $scope.model.difficulties =
        _.indexBy response, 'flash_card_id'
