PICKER_TEMPLATE = _.template '<ul class="list-unstyled"><li><%= character %></li><li><em><%= pronunciation %></em></li></ul>'
EMPTY_TEMPLATE = '<em>new</em>' 

lianxi.controller 'NewDrillController', ($scope, $cookies) ->
  $scope.cards = []

  $scope.enum =
    partsOfSpeech: null

  $.ajax
    url: STATIC.urls.partsOfSpeech
    success: (response) ->
      $scope.$apply ->
        $scope.enum.partOfSpeech = response
    error: (jqXHR, error, status) ->
      console.log error, status

  $scope.model =
    card: ->
      if _.isEmpty $scope.cards
        return null

      $scope.cards[$scope.cardIndex]

    character: (card) ->
      card[$cookies.charset] || card.simplified || card.traditional

    pronunciation: (card) ->
      card[$cookies.transcript] || card.pinyin || card.jyutping

  $scope.style =
    picker: (index) ->
      return if $scope.cardIndex == index then 'btn-default' else 'btn-link'

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
