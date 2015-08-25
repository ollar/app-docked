define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'views/common/overlay'
  'text!templates/top_menu.html'
  'models/loggedUser'
  'jquery.hammer'
  'translate'], ($, _, App, Mn, Overlay, TopMenuTemplate, LoggedUserModel, hammer, translate)->
  TopMenu = Mn.ItemView.extend
    tagName: 'nav'
    className: 'pure-menu'
    model: new LoggedUserModel()

    initialize: (options)->
      @options = options || {}
      @opened = no

      @moveX = 0
      @deltaX = 0
      @maxX = 200

      App.vent.on 'localUser:create:success localUser:update:success localUser:destroy:success', =>
        @render()

      App.vent.on 'menu:hide overlay:clicked', =>
        @closeMenu()

    ui:
      'open': '.open'
      'close': '.close'
      'menu': '.pure-menu'
      'panTab': '.pan-tab'

    events:
      "click @ui.open": "openMenu"
      "click @ui.close": "closeMenu"

      "mousedown": "touchStart"
      "touchstart": "touchStart"
      "mouseup": "touchEnd"
      "touchend": "touchEnd"

      "swiperight @ui.panTab": "openMenu"
      "swipeleft @ui.panTab": "closeMenu"
      'pan @ui.panTab': "panMenu"

    touchStart: ->
      @$el.addClass 'dragged'

    touchEnd: ->
      @$el.removeClass 'dragged'
      if (@moveX+@deltaX) > @moveX
        @openMenu()
      else
        @closeMenu()

    panMenu: (e)->
      @deltaX = e.gesture.deltaX
      if 0 > @moveX+@deltaX or @moveX+@deltaX > @maxX
        return

      @$el.css({'transform': 'translateX('+(@moveX+@deltaX)+'px)'})


    template: _.template(TopMenuTemplate)
    templateHelpers: ->
      t: translate

    openMenu: ->
      @moveX = @maxX
      @opened = yes
      App.vent.trigger "overlay:show"
      @toggleOpen()

    closeMenu: ->
      @moveX = 0
      @opened = no
      App.vent.trigger "overlay:hide"
      @toggleOpen()

    toggleOpen: ->
      @$el.toggleClass 'opened', @opened
      _.delay =>
        @$el.removeAttr 'style'
      , 30

    onBeforeRender: ->
      if $.cookie('id')?
        @model.id = $.cookie('id')
        @model.fetch()
      else
        @model = new LoggedUserModel()

    onRender: ->
      @hammer = @$el.find('.pan-tab').hammer()

      @

  TopMenu
