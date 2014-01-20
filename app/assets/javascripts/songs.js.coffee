YOUTUBE_TEMPLATE =
  _.template 'https://www.youtube.com/embed/<%= youtubeId %>?enablejsapi=1'
LYRICS_CONTEXT_LINES_TEMPLATE =
  _.template '<li class="text-muted"><%= previous %></li>' +
    '<li class="text-primary"><%= current %></li>' +
    '<li class="text-muted"><%= next %></li>'
ANNOTATION_TEMPLATE =
  _.template '<span class="label <%= classes %>"><%= text %></span>'

FIELD_ORDER = ['simplified', 'traditional', 'translation']
ANNOTATION_REGEX = /\[([^\s\n\[\]]+)\]/g
REWIND_LENGTH = 5 # seconds

lianxi.controller 'SongFormController', ($scope, $shared) ->
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

  lyricIndex = 0

  window.onYouTubeIframeAPIReady = ->
    $scope.player = new YT.Player 'youtube-player'

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
  $scope.model.song.title = "Fly"
  $scope.model.song.artist = "Vivienne Lu"
  $scope.model.song.dialect = "cantonese"
  $scope.model.song.youtubeId = "sYb6q0vGcr4"
  $scope.model.song.raw.simplified = "遇见你当天[一切]仍记忆犹新闭起眼仍看到\n从遇见你此刻感到情海轻飘过\n如果这天可许个愿愿和你一起去远飞\n从不管许多未来会如何仍要走过"
  $scope.model.song.raw.traditional = "遇見你當天[一切]仍記憶猶新閉起眼仍看到\n從遇見你此刻感到情海輕飄過\n如果這天可許個願願和你一起去遠飛\n從不管許多未來會如何仍要走過"
  $scope.model.song.raw.translation = "When I close my eye, the memory of meeting you that day is still very clear to me\nSince seeing you, till today, I feel like flying above of a sea of emotion\nIf I can make a wish today, I wish to fly away with you\nDoesn't matter how the future turns out. I will still search for it."

  watchRaw = (key) ->
    $scope.$watch 'model.song.raw.' + key, ->
      $scope.model.song[key] = splitLyrics $scope.model.song.raw[key]
      $scope.model.lyrics = computeLyrics()

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

  $scope.permissions =
    song:
      post: ->
        $scope.validators.song.lyrics()
    lyrics:
      showControls: ->
        $scope.validators.song.lyrics()
      setTime: ->
        lyrics = $scope.model.lyrics
        lyrics && lyricIndex < lyrics.length
      previousLyric: -> lyricIndex > 0
      nextLyric: ->
        lyrics = $scope.model.lyrics
        lyrics && lyricIndex < lyrics.length - 1

  $scope.display =
    lyrics:
      format:
        clean: (line) ->
          line[localStorage.charset].replace ANNOTATION_REGEX, '$1'
        tagged: (line) ->
          text = line[localStorage.charset]
          annotations = text.match ANNOTATION_REGEX
          cards = $shared.model.cards
          existingCards = []

          if cards
            existingCards = _.reduce cards, (valid, card) ->
              valid.push card.simplified
              valid.push card.traditional
              valid
            , []

          _.reduce annotations, (styledLine, annotation) ->
            annotatedText = annotation.replace /[\[\]]/g, ''
            valid = _.contains existingCards, annotatedText

            styledLine.replace annotation, ANNOTATION_TEMPLATE
              classes: if valid then 'label-success' else 'label-danger'
              text: annotatedText
          , text

      contextLines: ->
        lyrics = $scope.model.lyrics
        charset = localStorage.charset

        return '' unless lyrics

        lyricAt = (index) ->
          lyric = lyrics[index] && lyrics[index][charset] || '&nbsp;'
          lyric.replace ANNOTATION_REGEX, '$1'

        LYRICS_CONTEXT_LINES_TEMPLATE
          previous: lyricAt lyricIndex - 1
          current: lyricAt lyricIndex
          next: lyricAt lyricIndex + 1

  $scope.style =
    lyrics:
      row: (index) ->
        return if index == lyricIndex
          'text-primary'
        else
          'text-muted'

  $scope.handlers =
    annotations:
      add: (event) ->
        target = event.target
        start = target.selectionStart
        end = target.selectionEnd

        return if start == end

        annotate = (text) ->
          head = text.slice 0, start
          body = text.slice start, end
          tail = text.slice end, text.length - 1

          return text if body.match /[\n]/
          return text if body.match ANNOTATION_REGEX

          _.template '<%= head %>[<%= body %>]<%= tail %>',
            head: head
            body: body
            tail: tail

        $scope.model.song.raw.simplified =
          annotate $scope.model.song.raw.simplified
        $scope.model.song.raw.traditional =
          annotate $scope.model.song.raw.traditional

      remove: (event) ->
        target = event.target
        start = target.selectionStart
        end = target.selectionEnd

        return if start == end

        deannotate = (text) ->
          head = text.slice 0, start
          body = text.slice start, end
          tail = text.slice end, text.length - 1

          replacement = body.replace ANNOTATION_REGEX, '$1'

          head + replacement + tail

        $scope.model.song.raw.simplified =
          deannotate $scope.model.song.raw.simplified
        $scope.model.song.raw.traditional =
          deannotate $scope.model.song.raw.traditional

      modify: (event) ->
        meta = event.metaKey || event.ctrlKey
        shift = event.shiftKey
        code = event.keyCode == 69

        return unless meta and code and $scope.validators.song.lyrics()

        return if shift
          $scope.handlers.annotations.remove event
        else
          $scope.handlers.annotations.add event

    lyrics:
      selectRow: (index) ->
        lyricIndex = index
        timing = $scope.model.song.timing[index]

        return if not timing

        duration = $scope.player.getDuration()

        if 0 < timing and timing < duration
          $scope.player.seekTo timing
            
      setTime: ->
        $scope.model.song.timing[lyricIndex] =
          $scope.player.getCurrentTime()

        lyricIndex++
      stepBack: ->
        newTime = $scope.player.getCurrentTime() - REWIND_LENGTH
        newTime = 0 if newTime < 0
        lyricIndex-- if lyricIndex > 0
        $scope.player.seekTo(newTime)

      previousLyric: -> lyricIndex--
      nextLyric: -> lyricIndex++
