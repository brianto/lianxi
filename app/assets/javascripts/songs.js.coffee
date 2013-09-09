# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class Youtube
  @INTERVAL: 256 # Time between tick events

  # Youtube Events
  @ENDED: "ended"
  @PLAYING: "playing"
  @PAUSED: "paused"
  @BUFFERING: "buffering"
  @CUED: "cued"

  # Custom Events
  @TICK: "tick"

  @EVENTS: [@ENDED, @PLAYING, @PAUSED, @BUFFERING, @CUED]

  constructor: (@videoId) ->
    @$video = $ "##{@videoId}"

    @url = @$video.data "url"

    @player = new YT.Player @videoId,
      height: '240'
      width: '100%'
      videoId: @url # TODO refactor to something like youtube
      events:
        'onStateChange': @stateChange

  on: (event, callback) =>
    @$video.on event, callback

  start: =>
    if not @timer
      @timer = setInterval @tick, Youtube.INTERVAL

  stop: =>
    if @timer
      clearInterval @timer
      @timer = null

  tick: =>
    if @player
      @$video.trigger Youtube.TICK,
        time: @player.getCurrentTime()
        state: @player.getPlayerState()

  stateChange: (event) =>
    eventIndex = @player.getPlayerState()

    @$video.trigger Youtube.EVENTS[eventIndex], event

class Lyric
  constructor: (karaokeId) ->
    @$karaoke = $ "##{karaokeId}"
    @lines = $ ".lyric"
    @timings = _.map @lines, (line) =>
      return parseFloat $(line).data("timing"), 10

    @index = 0

  update_line: (time) =>
    index = 0

    index++ while @timings[index] < time

    index--

    if @index != index
      @index = index

      if @index < 0 # before start time
        @$karaoke.html "&nbsp;"
      else
        line = $ @lines[@index]
        @$karaoke.html line.html()

$(document).ready ->
  # Only apply for song#show
  return unless $("#songs.show").length

  # Initialize tooltips
  $(".tooltip-hint").tooltip();

  player = null
  lyric = new Lyric "karaoke-stub"

  window.onYouTubeIframeAPIReady = () ->
    player = new Youtube "video-stub"

    player.on Youtube.TICK, playerTick

    player.on Youtube.CUED, playerCued
    player.on Youtube.PAUSED, playerPaused
    player.on Youtube.BUFFERING, playerBuffering
    player.on Youtube.PLAYING, playerPlaying
    player.on Youtube.ENDED, playerEnded

    return player

  playerTick = (jqEvent, event) ->
    lyric.update_line event.time

  playerCued = (jqEvent, event) ->
    player.start()

  playerPaused = (jqEvent, event) ->
    player.stop()

  playerBuffering = (jqEvent, event) ->
    player.stop()

  playerPlaying = (jqEvent, event) ->
    player.start()

  playerEnded = (jqEvent, event) ->
    player.stop()
