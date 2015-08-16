define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'marionette'
  'text!templates/user/view.html'
  'translate'], ($, _, Backbone, App, Mn, Template, translate)->
  UserView = Mn.ItemView.extend
    className: 'user pure-menu-item'

    initialize: (options)->
      @options = options || {}
      @selected = no

    template: _.template Template
    templateHelpers: ->
      t: translate    

  UserView
