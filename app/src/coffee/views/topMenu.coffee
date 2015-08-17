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

    ui:
      'open': '.open'
      'close': '.close'
      'panTab': '.pan-tab'

    events:
      "click @ui.open": "openMenu"
      "click @ui.close": "closeMenu"

      "panright @ui.panTab": "openMenu"
      "panleft @ui.panTab": "closeMenu"

    initialize: (options)->
      @options = options || {}
      @opened = no

      App.vent.on 'localUser:create:success localUser:update:success localUser:destroy:success', =>
        @render()

      App.vent.on 'menu:hide', =>
        @closeMenu()

    template: _.template(TopMenuTemplate)
    templateHelpers: ->
      t: translate

    openMenu: ->
      @opened = yes
      App.overlay.show(new Overlay())
      @toggleOpen()

    closeMenu: ->
      @opened = no
      App.overlay.empty()
      @toggleOpen()

    toggleOpen: ->
      @$el.toggleClass 'opened', @opened

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
