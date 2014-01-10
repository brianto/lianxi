$(document).ready ->
  $('.examples-row').hide()

  $('.flash-card-row').on 'click', (event) ->
    $(this).next().toggle()

lianxi.controller 'CharacterTableController', ($scope, $cookies) ->
  $scope.show =
    simplified: -> $cookies.charset == 'simplified'
    traditional: -> $cookies.charset == 'traditional'
    pinyin: -> $cookies.transcript == 'pinyin'
    jyutping: -> $cookies.transcript == 'jyutping'
