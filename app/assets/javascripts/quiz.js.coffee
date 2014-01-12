lianxi.controller 'QuizController', ($scope, $cookies) ->

  configuring = false
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

    quiz:
      selection: 'all'
      visible:
        # TODO make this into prefs
        card:
          characters: true
          pronunciation: true
          partOfSpeech: true
          meaning: true
        example:
          characters: true
          pronunciation: true
          translation: true

  $scope.show =
    simplified: -> $cookies.charset == 'simplified'
    traditional: -> $cookies.charset == 'traditional'
    pinyin: -> $cookies.transcript == 'pinyin'
    jyutping: -> $cookies.transcript == 'jyutping'

    card:
      controls: ->
        not configuring
    example:
      container: ->
        not _.isEmpty $scope.model.examples()

  $scope.handlers =
    card:
      next: ->
        exampleIndex = 0
        cardIndex++
      previous: ->
        exampleIndex = 0
        cardIndex--

    example:
      next: ->
        exampleIndex++
      previous: ->
        exampleIndex--

    quiz:
      configure: ->
        configuring = not configuring
        $('.quiz-display').toggle()
        $('.quiz-config').toggle()

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

$(document).ready ->
  $('.quiz-config').hide()
