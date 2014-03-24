lianxi.controller 'PinController', ($scope) ->
  PIN_PATH = window.location + '/pin'

  $scope.model =
    pin: false

  $scope.style =
    pin: ->
      return if $scope.model.pin
        'glyphicon-star'
      else
        'glyphicon-star-empty'

  $scope.handlers =
    togglePin: ->
      $.ajax
        url: PIN_PATH
        type: 'POST'
      .done (pin) ->
        $scope.$apply ->
          $scope.model.pin = pin.pinned

  $.ajax
    url: PIN_PATH
  .done (pin) ->
    $scope.$apply ->
      $scope.model.pin = pin.pinned
