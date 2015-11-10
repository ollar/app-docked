require ['config'], ->
  require [
    'prefix'
    'jquery.cookie'
    'marionette'
    'router'
    'app'
    'views/topMenu'
    'views/common/overlay'
    'wreqr'
    ], (Prefix, jcookie, Mn, Router, App, TopMenu, Overlay, wreqr)->

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
