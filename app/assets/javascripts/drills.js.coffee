# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# TODO async call for data
window.lianxi.controller 'CharacterGridController', ($scope, $cookies) ->
  $.ajax
    url : window.location.href + '.json'
    success : (response) ->
      $scope.$apply ->
        $scope.model = response
    error : (jqXHR, status, error) ->
      console.log error

  $scope.display =
    character: (fc) ->
      fc[$cookies.charset]
    pronounciation: (fc) ->
      fc[$cookies.transcript]
