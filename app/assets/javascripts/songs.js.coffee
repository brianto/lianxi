# TODO make into multiline strings
YOUTUBE_TEMPLATE =
  _.template 'https://www.youtube.com/embed/<%= youtubeId %>?enablejsapi=1'
LYRICS_CONTEXT_LINES_TEMPLATE =
  _.template """
  <li class="text-muted"><%= previous %></li>
  <li class="text-primary"><%= current %></li>
  <li class="text-muted"><%= next %></li>
  """

ANNOTATION_PREVIEW_TEMPLATE =
  _.template '<span class="label <%= classes %>"><%= text %></span>'

LYRICS_DISPLAY_TEMPLATE =
  _.template """
  <ul class="list-unstyled">
    <li><%= lyrics %></li>
    <li><%= translation %></li>
  </ul>
  """
ANNOTATION_DISPLAY_TEMPLATE =
  _.template """
  <abbr class="text-primary"
    title="<%= meaning %>"><ruby class="annotation"><%= character %>
    <rt><%= transcript %></rt>
  </ruby></abbr>
  """

FIELD_ORDER = ['simplified', 'traditional', 'translation']
ANNOTATION_REGEX = /\[([^\s\n\[\]]+)\]/g
REWIND_LENGTH = 5 # seconds

lianxi.controller 'SongFormController', ($scope, $shared) ->
  $shared.includeScope $scope

  splitLyrics = (raw) ->
    lines = raw.split /\n/
    _.reject lines, (line) ->
      _.isEmpty line.trim()

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
  $scope.model.song.title = "Fly - Sleeping Dogs OST"
  $scope.model.song.artist = "Vivienne Lu (Lucy Liu)"
  $scope.model.song.dialect = "cantonese"
  $scope.model.song.youtubeId = "sYb6q0vGcr4"
  $scope.model.song.raw.simplified = """
[遇见]你[当天][一切][仍][记忆犹新][闭]起眼[仍]看到
从[遇见]你[此刻][感]到情海轻[飘]过
如果这天可[许]个[愿]愿和你一起去远飞
从[不管][许多]未来会[如何][仍]要走过

让我和你高飞
这[份]爱[可否]经得起[伤悲]
心[可否]为爱为情[撑]得起从未[放弃]到[余生]到[结束]
Take me away

为了你[抛开][一切][遥远]的情歌[此刻][仍]能听到
又为了你[深刻][感]到情海[翻滚]过
如果那天可[许]个[愿]愿和你一起去远飞
从[不管][许多]未来会[如何][仍]要走过

让我和你高飞
这[份]爱[可否]经得起[伤悲]
心[可否]为爱为情[撑]得起从未[放弃]到[余生]到[结束]
Take me away

[张开][拥抱]双手[抱紧][彼此]内心
[冲开][一切][飘]过心里的那片白云[期待]爱

让我和你高飞
这[份]爱[可否]经得起[伤悲]
心[可否]为爱为情[撑]得起从未[放弃]到[余生]到[结束]

让我和你高飞
这[份]爱[可否]经得起[伤悲]
心[可否]为爱为情[撑]得起从未[放弃]到[余生]到[结束]
Take me away

[遇见]你[当天][一切][仍][记忆犹新][闭]起眼[仍]看到你
"""
  $scope.model.song.raw.traditional = """
[遇見]你[當天][一切][仍][記憶猶新][閉]起眼[仍]看到
從[遇見]你[此刻][感]到情海輕[飄]過
如果這天可[許]個[願]願和你一起去遠飛
從[不管][許多]未來會[如何][仍]要走過

讓我和你高飛
這[份]愛[可否]經得起[傷悲]
心[可否]為愛為情[撐]得起從未[放棄]到[餘生]到[結束]
Take me away

為了你[拋開][一切][遙遠]的情歌[此刻][仍]能聽到
又為了你[深刻][感]到情海[翻滾]過
如果那天可[許]個[願]願和你一起去遠飛
從[不管][許多]未來會[如何][仍]要走過

讓我和你高飛
這[份]愛[可否]經得起[傷悲]
心[可否]為愛為情[撐]得起從未[放棄]到[餘生]到[結束]
Take me away

[張開][擁抱]雙手[抱緊][彼此]內心
[沖開][一切][飄]過心裏的那片白雲[期待]愛

讓我和你高飛
這[份]愛[可否]經得起[傷悲]
心[可否]為愛為情[撐]得起從未[放棄]到[餘生]到[結束]

讓我和你高飛
這[份]愛[可否]經得起[傷悲]
心[可否]為愛為情[撐]得起從未[放棄]到[餘生]到[結束]
Take me away

[遇見]你[當天][一切][仍][記憶猶新][閉]起眼[仍]看到你
"""
  $scope.model.song.raw.translation = """When I close my eye, the memory of meeting you that day is still very clear to me
Since seeing you, till today, I feel like flying above of a sea of emotion
If I can make a wish today, I wish to fly away with you
Doesn't matter how the future turns out. I will still search for it.
Let's fly away.
Wonder if this love can survive through sorrow.
Wonder if my heart can stand. But I never give up, till the rest of my life, till the end.
Take me away
To be with you, I don't care anything else. Soft romantic tunes, I can still recall.
And to be with you, I feel deeply my sea of emotion is roaring
If I can make a wish that day, I wish to fly away with you
Doesn't matter how the future turns out. I will still search for it.
Let's fly away.
Wonder if this love can survive through sorrow.
Wonder if my heart can stand. But I never give up, till the rest of my life, till the end.
Take me away
Let's embrace each other, holding tightly, from the heart.
Overcome all obstacles, fly over the cloud in the heart, and expect the love.
Let's fly away.
Wonder if this love can survive through sorrow.
Wonder if my heart can stand. But I never give up, till the rest of my life, till the end.
Let's fly away.
Wonder if this love can survive through sorrow.
Wonder if my heart can stand. But I never give up, till the end of life, till the end.
Take me away
When I close my eye, the memory of meeting you that day is still very clear to me"""
  $scope.model.song.timing = [
    22.4, 32.8, 43.9, 54.5,
    64.5, 68.5, 74.1, 86.3,
    98.7, 109.1, 120.3, 131.1,
    140.7, 144.9, 150.5, 162.7,
    166.3, 175.7, 184.7, 188.7,
    194.1, 206.3, 210.3, 215.9,
    228.1, 229.4 ]

  if globals.urls.get
    $.ajax
      url: globals.urls.get
    .done (response) ->
      $scope.$apply ->
        $scope.model.song.raw =
          simplified: response.song.simplified
          traditional: response.song.traditional
          translation: response.song.translation
        $scope.model.song.timing = response.song.timing
        $scope.model.song.title = response.song.title
        $scope.model.song.artist = response.song.artist
        $scope.model.song.youtubeId = response.song.youtubeId
        $scope.model.song.dialect = response.song.dialect

        cards = $shared.model.cards
        cards.length = 0
        _.each response.cards, (card) ->
          cards.push card

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

            styledLine.replace annotation, ANNOTATION_PREVIEW_TEMPLATE
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
          tail = text.slice end, text.length

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
          tail = text.slice end, text.length

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

lianxi.controller 'KaraokeController', ($scope, $shared) ->
  $shared.includeScope $scope

  $scope.model =
    song: {}

  $.ajax
    url: globals.urls.get
  .done (response) ->
    $scope.$apply ->
      $scope.model.song = _.clone response.song
      $scope.model.cards = response.cards
      $scope.model.song.raw =
        simplified: response.song.simplified
        traditional: response.song.traditional
        translation: response.song.translation
      $scope.model.song.timing = response.song.timing || []

      _.each FIELD_ORDER, (key) ->
        $scope.model.song[key] = response.song[key].split /\n+/

      verses = response.song.simplified.split /\n{2,}/

      sliceArgs = _.chain(verses)
      .map (verse) ->
        verse.split(/\n/).length
      .reduce((splitIndicies, length, index) ->
        splitIndicies.push splitIndicies[index] + length
        splitIndicies
      , [0])
      .reduce((runningIndicies, end, listIndex, list) ->
        start = list[listIndex - 1]
        runningIndicies.push [start, end]
        runningIndicies
      , [])
      .value()
      .splice 1 # lop off first element, start is undefined

      rawTransposedLyrics = _.zip.apply _,
        _.map FIELD_ORDER, (key) ->
          $scope.model.song[key]

      lyrics = _.map rawTransposedLyrics, (rawTransposedLyric, lineIndex) ->
        lyricObj = _.reduce rawTransposedLyric, (lyric, item, fieldIndex) ->
          fieldName = FIELD_ORDER[fieldIndex]
          lyric[fieldName] = item
          lyric
        , { id: lineIndex }

        lyricObj.timing = $scope.model.song.timing[lineIndex]
        lyricObj

      $scope.model.song.verses = _.reduce sliceArgs, (verses, sliceArg) ->
        verses.push lyrics.slice.apply lyrics, sliceArg
        verses
      , []

      $scope.model.song.lyrics = _.flatten $scope.model.song.verses

  $scope.show =
    song:
      simplified: -> localStorage.charset == 'simplified'
      traditional: -> localStorage.charset == 'traditional'

  $scope.display =
    lyrics:
      format:
        tooltipped: (line) ->
          rawLyrics = line[localStorage.charset]

          annotations = rawLyrics.match ANNOTATION_REGEX

          annotatedLyrics = _.reduce annotations, (lyrics, annotation) ->
            hanzi = annotation.replace /[\[\]]/g, ''

            card = _.find $scope.model.cards, (candidateCard) ->
              _.chain(['simplified', 'traditional'])
              .map (field) ->
                candidateCard[field] == hanzi
              .any()
              .value()

            if not card
              return lyrics.replace annotation, hanzi

            lyrics.replace annotation, ANNOTATION_DISPLAY_TEMPLATE
              character: card[localStorage.charset]
              transcript: card[localStorage.transcript]
              partOfSpeech: card.part_of_speech
              meaning: card.meaning
          , rawLyrics

          LYRICS_DISPLAY_TEMPLATE
            lyrics: annotatedLyrics
            translation: line.translation
