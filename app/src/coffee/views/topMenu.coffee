define [
  'app'
  'marionette'
  'views/common/overlay'
  'text!templates/top_menu.html'
  'models/loggedUser'

  'behaviors/draggable'
  'behaviors/link'
  ], (App, Mn, Overlay, TopMenuTemplate, LoggedUserModel, Draggable, Link)->
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
        callback: @panCallback.bind(@)
        disable: =>
          (@move.get('gesture').direction == 4 && @move.get('X') > 200) ||
          (@move.get('gesture').direction == 2 && @move.get('X') < 0)
      Link:
        behaviorClass: Link

    ui:
      'toggle': '.toggle'
      'panEl': '.pan-tab'

    events:
      "click @ui.toggle": "toggleOpen"

    template: _.template(TopMenuTemplate)

    panCallback: ->
      if @move.get('gesture').direction == 4
        @opened = yes
        @move.set({X:200, oldX: 200})
      else if @move.get('gesture').direction == 2
        @opened = no
        @move.set({X:0, oldX: 0})
      else
        @opened = !@opened

      @updateState()

    toggleOpen: ->
      @opened = !@opened
      @$el.removeAttr 'style'

      @updateState()

    updateState: ->
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
