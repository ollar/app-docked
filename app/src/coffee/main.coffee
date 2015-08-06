require [
  'app'
  'jquery'
  'underscore'
  'backbone'
  'router'
  'models/loggedUser'
  'jquery.cookie'
  'marked'], (App, $, _, Backbone, AppRouter, LoggedUser, jcookie, marked)->
  $.fn.serializeObject = ->
    o = {}
    a = @serializeArray()
    $.each a, ->
      if o[@name] != undefined
        if !o[@name].push
          o[@name] = [ o[@name] ]
        o[@name].push @value or ''
      else
        o[@name] = @value or ''
      return
    o

  $.ajaxSetup
    contentType: "application/json; charset=utf-8"
    dataType: "json"

  $.ajaxPrefilter ( options, originalOptions, jqXHR ) ->
    options.url = 'http://flask:5000' + options.url

    options.crossDomain =
      crossDomain: true

    options.beforeSend = (xhr)->
      if $.cookie 'access_token'
        xhr.setRequestHeader 'access-token', $.cookie 'access_token'

  $(document).on 'ajaxStart', ->
    channel = require('channel')
    channel.trigger 'loading:start'

  $(document).on 'ajaxComplete', ->
    channel = require('channel')
    channel.trigger 'loading:done'

  App.router = new AppRouter()

  marked.setOptions
    renderer: new marked.Renderer()
    gfm: true
    tables: true
    breaks: false
    pedantic: false
    sanitize: true
    smartLists: true
    smartypants: false

  Backbone.history.start()
    # root: '/bb_app'
    # pushState: yes

  return
