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

      $('#main-wrapper').removeClass('loading')

    # ====================================
    # Specifying regions
    # ====================================

    MainRegion = Mn.Region.extend
      show: (view, options)->
        _args = arguments
        App.vent.trigger 'loading:start'
        @$el.addClass('page-change')

        _.delay =>
          Mn.Region::show.apply(@, _args)
        , 400

        _.delay =>
          App.vent.trigger 'loading:done'
          @$el.removeClass('page-change')
        , 700

    App.addRegions
      navigation: "#navigation"
      messages: "#message-wrapper"
      overlay: "#overlay"
      main:
        regionClass: MainRegion
        selector: "#main-content"

    # ====================================
    # Starting the App
    # ====================================

    App.start()
