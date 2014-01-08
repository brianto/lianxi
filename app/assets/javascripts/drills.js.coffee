lianxi.controller 'DrillFormController', ($scope, $cookies) ->
  $scope.model =
    drill:
      title: ''
      description: ''

  $scope.permissions =
    drill:
      create: ->
        !_.chain($scope.model.drill)
        .values()
        .any(_.isEmpty)
        .value()
