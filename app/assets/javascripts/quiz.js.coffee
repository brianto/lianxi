lianxi.controller 'QuizController', ($scope, $cookies) ->
  $scope.model =
    cards: null
    card: ->
      cards = $scope.model.cards

      return if _.isEmpty $scope.model.cards
        null 
      else
        $scope.model.cards[$scope.cardIndex]

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
        examples[$scope.exampleIndex]

  $scope.show =
    simplified: -> $cookies.charset == 'simplified'
    traditional: -> $cookies.charset == 'traditional'
    pinyin: -> $cookies.transcript == 'pinyin'
    jyutping: -> $cookies.transcript == 'jyutping'

  $.ajax
    url: globals.jsonUrl
  .done (response) ->
    cards = response.cards

    if not _.isEmpty cards
      $scope.$apply ->
        $scope.model.cards = response.cards
        $scope.cardIndex = 0
        $scope.exampleIndex = 0
      
  .fail (jqXHR, status, error) ->
    debugger

$(document).ready ->
  $('.quiz-config').hide()

  $('button').click ->
    $('.quiz-display').toggle()
    $('.quiz-config').toggle()
