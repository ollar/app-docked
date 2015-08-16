define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'marionette'
  # 'channel'
  'views/common/overlay'
  'text!templates/top_menu.html'
  'models/loggedUser'
  'jquery.hammer'
  'translate'], ($, _, Backbone, App, Mn, Overlay, TopMenuTemplate, LoggedUserModel, hammer, translate)->
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
      @model.fetch()



      # @listenTo channel, 'localUser:create:success localUser:update:success localUser:destroy:success', ->
      #   @render()
      #
      # @listenTo channel, 'menu:hide', ->
      #   @closeMenu()

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

    onRender: ->
      @hammer = @$el.find('.pan-tab').hammer()

      @

  TopMenu
