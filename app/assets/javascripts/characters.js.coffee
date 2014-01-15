$(document).ready ->
  $('.examples-row').hide()

  $('.flash-card-row').on 'click', (event) ->
    $(this).next().toggle()

lianxi.controller 'CharacterTableController', ($scope) ->
  $scope.show =
    simplified: -> localStorage.charset == 'simplified'
    traditional: -> localStorage.charset == 'traditional'
    pinyin: -> localStorage.transcript == 'pinyin'
    jyutping: -> localStorage.transcript == 'jyutping'
