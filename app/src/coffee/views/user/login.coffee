define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'channel'
  'text!templates/user/login.html'
  'models/loggedUser'
  'translate'], ($, _, Backbone, App, channel, LoginTemplate, LoggedUserModel, translate) ->

  LoginView = Backbone.View.extend

    className: "login-form"

    template: _.template(LoginTemplate)

    events:
      'submit #login_form': 'submitForm'

    initialize: (options)->
      @options = options || {}

    loginUser: (data)->
      $.cookie 'id', data.id
      $.cookie 'access_token', data.token

      channel.trigger 'localUser:create', data
      channel.trigger 'message',
        text: 'Welcome, <b>'+data.username+'</b>'

      App.router.navigate '', yes

    submitForm: (e)->
      e.preventDefault()

      formData = $(e.target).serializeObject()

      $.post '/user/login', JSON.stringify(formData), (data, status, xhr)=>
        @loginUser(data)


    render: ->
      @$el.html @template({t: translate})
      @

  LoginView
