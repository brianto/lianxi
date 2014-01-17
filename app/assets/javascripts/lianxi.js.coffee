window.lianxi = angular.module 'lianxi', ['ngCookies', 'ngSanitize']

lianxi.config ($sceDelegateProvider) ->
  $sceDelegateProvider.resourceUrlWhitelist [
    'self',
    'http://youtube.com/embed/*'
  ]

window.STATIC =
  urls:
    hanziMap: '/hanzimap.json'

window.globals = {}

lianxi.service '$shared', ->
  SHARED_KEYS = [ 'loaders', 'model', 'display', 'permissions' ]

  scopes = []
  api = {}

  _.each SHARED_KEYS, (key) ->
    Object.defineProperty api, key,
      get: ->
        _.reduce scopes, (definitions, scope) ->
          _.extend definitions, scope[key]
        , {}

  api.includeScope = (scope) ->
    scopes.push scope

  return api
