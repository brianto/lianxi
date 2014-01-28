lianxi.controller 'QuizController', ($scope) ->
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

    quiz: if localStorage.quiz
        JSON.parse localStorage.quiz
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
    simplified: -> localStorage.charset == 'simplified'
    traditional: -> localStorage.charset == 'traditional'
    pinyin: -> localStorage.transcript == 'pinyin'
    jyutping: -> localStorage.transcript == 'jyutping'

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
      pronunciation: -> $scope.style._quizStyleBlur 'card', 'pronunciation'
      characters: -> $scope.style._quizStyleBlur 'card', 'characters'
      partOfSpeech: -> $scope.style._quizStyleBlur 'card', 'partOfSpeech'
      meaning: -> $scope.style._quizStyleBlur 'card', 'meaning'

    example:
      characters: -> $scope.style._quizStyleBlur 'example', 'characters'
      translation: -> $scope.style._quizStyleBlur 'example', 'translation'

  shuffleCards = ->
    cards = _.shuffle $scope.model.cards
    difficulties = $scope.model.difficulties

    difficultyOf = (card) ->
      return null if not card
      difficultyRef = $scope.model.difficulties[card.id]
      return null if not difficultyRef
      difficultyRef.difficulty

    ORDERING = { hard: -1, easy: 1 }

    switch $scope.model.quiz.selection
      when 'hardest-first'
        cards = _.sortBy cards, (card) ->
          difficulty = difficultyOf card
          ORDERING[difficulty] || 0
      when 'easiest-first'
        cards = _.sortBy cards, (card) ->
          difficulty = difficultyOf card
          -ORDERING[difficulty] || 0

    $scope.$apply ->
      $scope.model.cards = cards

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

        $.ajax
          url: globals.urls.difficulties.post
          type: 'POST'
          data: difficultyRef

      easy: -> $scope.handlers.difficulty._update 'easy'
      hard: -> $scope.handlers.difficulty._update 'hard'

    quiz:
      reveal: ->
        revealing = not revealing
      configure: ->
        configuring = not configuring
      reorder: ->
        shuffleCards()

  $scope.permissions =
    action: ->
      not configuring
    card:
      difficulty: ->
        not _.isEmpty $scope.model.cards
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
    localStorage.quiz = current

  cardsAjax = $.ajax
    url: globals.urls.get
  .done (response) ->
    cards = response.cards

    if not _.isEmpty cards
      $scope.$apply ->
        $scope.model.cards = response.cards
        cardIndex = 0
        exampleIndex = 0
      
  .fail (jqXHR, status, error) ->
    debugger

  difficultiesAjax = $.ajax
    url: globals.urls.difficulties.get
  .done (response) ->
    $scope.$apply ->
      $scope.model.difficulties =
        _.indexBy response, 'flash_card_id'

  $.when(cardsAjax, difficultiesAjax).done ->
    shuffleCards()
