window.lianxi = angular.module 'lianxi', ['ngCookies', 'ngSanitize']

window.STATIC =
  urls:
    hanziMap: '/hanzimap.json'

lianxi.service '$shared', ->
  SHARED_KEYS = [ 'model', 'display', 'permissions' ]

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
