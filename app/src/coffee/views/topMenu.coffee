define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'views/common/overlay'
  'text!templates/top_menu.html'
  'models/loggedUser'

  'translate'
  'behaviors/draggable'
  ], ($, _, App, Mn, Overlay, TopMenuTemplate, LoggedUserModel, translate, Draggable)->
  TopMenu = Mn.ItemView.extend
    tagName: 'nav'
    className: 'pure-menu'
    model: new LoggedUserModel()

    initialize: (options)->
      @options = options || {}
      @opened = no

      App.vent.on 'localUser:update:success localUser:destroy:success', =>
        @render()

      App.vent.on 'menu:hide overlay:clicked', =>
        @opened = yes
        @toggleOpen()

    behaviors: ->
      Draggable:
        behaviorClass: Draggable
        direction: 'H'
        callback: _.bind(@toggleOpen, @)

    ui:
      'toggle': '.toggle'
      'panEl': '.pan-tab'

    events:
      "click @ui.toggle": "toggleOpen"

    template: _.template(TopMenuTemplate)
    templateHelpers: ->
      t: translate

    toggleOpen: (e)->
      @opened = !@opened
      @$el.toggleClass 'opened', @opened

      if @opened
        App.vent.trigger "overlay:show"
      else
        App.vent.trigger "overlay:hide"

    onBeforeRender: ->
      if $.cookie('id')?
        @model.id = $.cookie('id')
        @model.fetch()
      else
        @model = new LoggedUserModel()

  TopMenu
