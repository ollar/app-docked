define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'text!templates/user/view.html'
  'translate'
  'behaviors/select'
  ], ($, _, App, Mn, Template, translate, Select)->
  UserView = Mn.ItemView.extend
    className: 'user pure-menu-item'

    initialize: (options)->
      @options = options || {}
      @selected = no

    template: _.template Template
    templateHelpers: ->
      t: translate

    behaviors:
      Select:
        behaviorClass: Select

  UserView
