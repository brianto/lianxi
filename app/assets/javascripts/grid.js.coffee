lianxi.controller 'CharacterGridController', ($scope) ->
  $scope.show =
    simplified: -> localStorage.charset == 'simplified'
    traditional: -> localStorage.charset == 'traditional'
    pinyin: -> localStorage.transcript == 'pinyin'
    jyutping: -> localStorage.transcript == 'jyutping'
