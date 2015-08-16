define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'channel'
  'text!templates/top_menu.html'
  'models/loggedUser'
  'jquery.hammer'
  'translate'], ($, _, Backbone, App, channel, TopMenuTemplate, LoggedUserModel, hammer, translate)->
  TopMenu = Backbone.View.extend
    el: '#navigation'

    events:
      "click .open": "openMenu"
      "click .close": "closeMenu"
      "click .overlay": "closeMenu"
      "panright .pan-tab": "openMenu"
      "panleft .pan-tab": "closeMenu"

    initialize: (options)->
      @options = options || {}
      @opened = no

      @listenTo channel, 'localUser:create:success localUser:update:success localUser:destroy:success', ->
        @render()

      @listenTo channel, 'menu:hide', ->
        @closeMenu()

      @render()

    template: _.template(TopMenuTemplate)

    openMenu: ->
      @opened = yes
      @toggleOpen()

    closeMenu: ->
      @opened = no
      @toggleOpen()

    toggleOpen: ->
      @$el.toggleClass 'opened', @opened

    render: ->
      loggedUser = new LoggedUserModel({id: $.cookie 'id'})

      loggedUser.fetch
        success: (model, response, options)=>
          @$el.html @template {user: model.toJSON(), t: translate}

      @menu = @$el.find('#menu')
      @hammer = @$el.find('.pan-tab').hammer()

      @

  TopMenu
