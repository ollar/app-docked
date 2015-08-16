define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'text!templates/user/view.html'
  'views/user/form'
  'channel'
  'translate'], ($, _, Backbone, App, usersViewTemplate, UserFormView, channel, translate)->
  UserView = Backbone.View.extend
    tagName: 'li'
    className: 'user pure-menu-item'

    initialize: (options)->
      @options = options || {}
      @selected = no

      @on 'stateToggle', ->
        @selected = !@selected
        @selectToggle()

      @on 'select', ->
        @selected = yes
        @selectToggle()

      @listenTo @model, 'destroy', ->
        @remove()

    events:
      'click': 'stateToggle'
      'click .edit': 'editUser'
      'click .remove': 'removeUser'

    template: _.template(usersViewTemplate)

    editUser: ->
      userFormView = new UserFormView
        model: @model
        front_view: UserView

      @$el.before userFormView.render().el
      @remove()

    stateToggle: ->
      @trigger 'stateToggle'

    selectToggle: ->
      @$el.toggleClass 'selected', @selected

    removeUser: ->
      @model.destroy
        success: (model, response, options)=>
          channel.trigger 'message',
            text: 'user "<i>'+model.get('id')+'</i>" removed'

    render: ()->
      @$el.html @template(_.extend @model.toJSON(), {t: translate})
      @$el.attr('data-id', @model.get('id'))
      @$el.toggleClass 'selected', @selected

      return @


  UserView
