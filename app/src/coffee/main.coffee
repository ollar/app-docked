require ['config'], ->
  require [
    'jquery.cookie'
    'marionette'
    'router'
    'marked'
    'app'
    'views/topMenu'
    'views/common/overlay'
    'wreqr'
    'env'
    'translate'
    ], (jcookie, Mn, Router, marked, App, TopMenu, Overlay, wreqr, ENV, translate)->

    # ====================================
    # Setting help functions and options
    # ====================================

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

    marked.setOptions
      renderer: new marked.Renderer()
      gfm: true
      tables: true
      breaks: false
      pedantic: false
      sanitize: true
      smartLists: true
      smartypants: false

    # ====================================

    # ====================================

    App.navigate = (route)->
      Backbone.history.navigate route, yes

    # ====================================
    # Preparing app
    # ====================================

    Mn.Behaviors.behaviorsLookup = ->
      App.Behaviors

    App.on "before:start", ->
      @navigation.show(new TopMenu())
      @overlay.show(new Overlay())

      _.mixin
        t: translate

      $.ajaxPrefilter ( options, originalOptions, jqXHR ) ->
        # options.url = 'http://localhost:5000' + options.url
        options.url = 'http://' + ENV.prod_ip + ':5000' + options.url
        options.dataType = "jsonp"
        options.crossDomain = yes
        options.contentType = "application/json; charset=utf-8"

        options.beforeSend = (xhr)->
          if $.cookie 'access_token'
            xhr.setRequestHeader 'access-token', $.cookie 'access_token'


    App.on 'start', ->
      new Router()
      Backbone.history.start
        pushState: true
        root: '/'

    # ====================================
    # Specifying regions
    # ====================================

    App.addRegions
      navigation: "#navigation"
      main: "#main-content"
      messages: "#message-wrapper"
      overlay: "#overlay"

    # ====================================
    # Starting the App
    # ====================================

    App.start()

    return
