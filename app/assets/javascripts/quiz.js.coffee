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
    card:
      controls: ->
        not configuring
    example:
      container: ->
        not _.isEmpty $scope.model.examples()

  $scope.style =
    card:
      pronunciation: ->
        return if not $scope.model.quiz.visible.card.pronunciation && not revealing
          'quiz-blur'
      characters: ->
        return if not $scope.model.quiz.visible.card.characters && not revealing
          'quiz-blur'
      partOfSpeech: ->
        return if not $scope.model.quiz.visible.card.partOfSpeech && not revealing
          'quiz-blur'
      meaning: ->
        return if not $scope.model.quiz.visible.card.meaning && not revealing
          'quiz-blur'

    example:
      characters: ->
        return if not $scope.model.quiz.visible.example.characters && not revealing
          'quiz-blur'
      translation: ->
        return if not $scope.model.quiz.visible.example.translation && not revealing
          'quiz-blur'

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
      next: ->
        exampleIndex++
      previous: ->
        exampleIndex--

    quiz:
      reveal: ->
        revealing = not revealing
      configure: ->
        configuring = not configuring

  $scope.permissions =
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
