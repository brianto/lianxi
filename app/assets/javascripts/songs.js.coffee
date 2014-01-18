YOUTUBE_TEMPLATE = _.template 'http://youtube.com/embed/<%= youtubeId %>'
FIELD_ORDER = ['simplified', 'traditional', 'translation']

lianxi.controller 'SongFormController', ($scope, $shared, $sceDelegate) ->
  splitLyrics = (raw) ->
    lines = raw.split /\n/
    _.reject lines, _.isEmpty

  computeLyrics = ->
    return null unless $scope.validators.song.lyrics()

    lyricFields = _.map FIELD_ORDER, (field) ->
      $scope.model.song[field] || []

    _.map _.zip.apply(_, lyricFields), (line, id) ->
      _.reduce line, (lineObj, fieldValue, index) ->
        fieldName = FIELD_ORDER[index]
        lineObj[fieldName] = fieldValue
        lineObj
      , { id: id }

  $scope.model =
    song:
      title: ''
      artist: ''
      youtubeId: ''
      dialect: 'mandarin'
      raw:
        simplified: ''
        traditional: ''
        translation: ''

      youtubeUrl: ->
        YOUTUBE_TEMPLATE
          youtubeId: $scope.model.song.youtubeId

      # lyrics: ''
      timing: []

  # For testing, remove later
  $scope.model.song.youtubeId = "sYb6q0vGcr4"
  $scope.model.song.raw.simplified = "遇见你当天一切仍记忆犹新闭起眼仍看到\n从遇见你此刻感到情海轻飘过\n如果这天可许个愿愿和你一起去远飞\n从不管许多未来会如何仍要走过"
  $scope.model.song.raw.traditional = "遇見你當天一切仍記憶猶新閉起眼仍看到\n從遇見你此刻感到情海輕飄過\n如果這天可許個願願和你一起去遠飛\n從不管許多未來會如何仍要走過"
  $scope.model.song.raw.translation = "When I close my eye, the memory of meeting you that day is still very clear to me\nSince seeing you, till today, I feel like flying above of a sea of emotion\nIf I can make a wish today, I wish to fly away with you\nDoesn't matter how the future turns out. I will still search for it."

  watchRaw = (key) ->
    $scope.$watch 'model.song.raw.' + key, ->
      $scope.model.song[key] = splitLyrics $scope.model.song.raw[key]
      $scope.model.song.lyrics = computeLyrics()

  _.chain($scope.model.song.raw)
  .keys()
  .each(watchRaw)

  $scope.validators =
    song:
      lyrics: ->
        song = $scope.model.song
        lengths = _.reduce FIELD_ORDER, (lengths, fieldName) ->
          field = song[fieldName]
          lengths[fieldName] = field && field.length || 0
          lengths
        , {}

        noEmptyFields = _.all _.values lengths
        sameHanziLengths = song.raw.simplified.length == song.raw.traditional.length
        sameNumberOfLines = _.all [
          lengths.simplified == lengths.traditional,
          lengths.simplified == lengths.translation,
          lengths.traditional == lengths.translation
        ]

        _.all [noEmptyFields, sameHanziLengths, sameNumberOfLines]

  $scope.show =
    simplified: -> localStorage.charset == 'simplified'
    traditional: -> localStorage.charset == 'traditional'

# class Youtube
#   @INTERVAL: 256 # Time between tick events

#   # Youtube Events
#   @ENDED: "ended"
#   @PLAYING: "playing"
#   @PAUSED: "paused"
#   @BUFFERING: "buffering"
#   @CUED: "cued"

#   # Custom Events
#   @TICK: "tick"

#   @EVENTS: [@ENDED, @PLAYING, @PAUSED, @BUFFERING, @CUED]

#   constructor: (@videoId) ->
#     @$video = $ "##{@videoId}"

#     @url = @$video.data "url"

#     @player = new YT.Player @videoId,
#       height: '240'
#       width: '100%'
#       videoId: @url # TODO refactor to something like youtube
#       events:
#         'onStateChange': @stateChange

#   on: (event, callback) =>
#     @$video.on event, callback

#   start: =>
#     if not @timer
#       @timer = setInterval @tick, Youtube.INTERVAL

#   stop: =>
#     if @timer
#       clearInterval @timer
#       @timer = null

#   tick: =>
#     if @player
#       @$video.trigger Youtube.TICK,
#         time: @player.getCurrentTime()
#         state: @player.getPlayerState()

#   stateChange: (event) =>
#     eventIndex = @player.getPlayerState()

#     @$video.trigger Youtube.EVENTS[eventIndex], event

# class Lyric
#   constructor: (karaokeId) ->
#     @$karaoke = $ "##{karaokeId}"
#     @lines = $ ".lyric"
#     @timings = _.map @lines, (line) =>
#       return parseFloat $(line).data("timing"), 10

#     @index = 0

#   update_line: (time) =>
#     index = 0

#     index++ while @timings[index] < time

#     index--

#     if @index != index
#       @index = index

#       if @index < 0 # before start time
#         @$karaoke.html "&nbsp;"
#       else
#         line = $ @lines[@index]
#         @$karaoke.html line.html()
#         @$karaoke.find(".tooltip-hint").tooltip()

# $(document).ready ->
#   # Only apply for song#show
#   return unless $("#songs.show").length

#   # Initialize tooltips
#   $(".tooltip-hint").tooltip();

#   player = null
#   lyric = new Lyric "karaoke-stub"

#   window.onYouTubeIframeAPIReady = () ->
#     player = new Youtube "video-stub"

#     player.on Youtube.TICK, playerTick

#     player.on Youtube.CUED, playerCued
#     player.on Youtube.PAUSED, playerPaused
#     player.on Youtube.BUFFERING, playerBuffering
#     player.on Youtube.PLAYING, playerPlaying
#     player.on Youtube.ENDED, playerEnded

#     return player

#   playerTick = (jqEvent, event) ->
#     lyric.update_line event.time

#   playerCued = (jqEvent, event) ->
#     player.start()

#   playerPaused = (jqEvent, event) ->
#     player.stop()

#   playerBuffering = (jqEvent, event) ->
#     player.stop()

#   playerPlaying = (jqEvent, event) ->
#     player.start()

#   playerEnded = (jqEvent, event) ->
#     player.stop()
