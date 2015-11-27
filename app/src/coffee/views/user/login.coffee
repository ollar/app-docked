define [
  'app'
  'marionette'
  'text!templates/user/login.html'
  ], (App, Mn, LoginTemplate) ->

  LoginView = Mn.ItemView.extend

    className: "login-form"

    template: _.template(LoginTemplate)

    events:
      'submit #login_form': 'submitForm'

    initialize: (options)->
      @options = options || {}

    loginUser: (data)->
      $.cookie 'id', data.id
      $.cookie 'access_token', data.token

      App.ventFunctions.updateLocalUser ->
        App.execute 'message',
          text: _.t 'welcome username', data.username

        App.navigate ''

    submitForm: (e)->
      e.preventDefault()

      formData = $(e.target).serializeObject()

      App.ajax
        type: 'post'
        url: '/user/login'
        data: JSON.stringify(formData)
        success: (data, status, xhr)=>
          @loginUser(data)

  LoginView
