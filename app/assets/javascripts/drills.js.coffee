lianxi.controller 'DrillFormController', ($scope, $shared) ->
  $shared.includeScope $scope

  if globals.urls.get
    $.ajax
      url: globals.urls.get
    .done (response) ->
      $scope.$apply ->
        $scope.model.drill = response.drill

        cards = $shared.model.cards
        cards.length = 0
        _.each response.cards, (card) ->
          cards.push card

  window.onbeforeunload = -> "You have unsaved changes."

  $scope.model =
    drill:
      title: ''
      description: ''

  $scope.permissions =
    drill:
      post: ->
        not _.chain($scope.model.drill)
        .pick(['title', 'description'])
        .any(_.isEmpty)
        .value()
