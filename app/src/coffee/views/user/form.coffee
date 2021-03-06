define [
  'app'
  'marionette'
  'text!templates/user/form.html'
  'models/user'
  'views/user/login'
  ], (App, Mn, userFormTemplate, UserModel, LoginView)->
  UserFormView = Mn.ItemView.extend
    className: 'user-manage pure-menu-item'

    initialize: (options)->
      @options = options || {}
      @model = @options.model || new UserModel()
      if @options.user_id
        @model.set({'id':@options.user_id})
        @model.fetch
          success: =>
            @render()
          error: (collection, response, options)=>
            App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}
      @uid = @model.get('id')

    template: _.template(userFormTemplate)

    events:
      'submit #user_form': 'updateUser'
      'click .cancel': 'cancelEdit'

    updateUser: (e)->
      e.preventDefault()
      formData = $(e.target).serializeObject()
      @model.save formData,
        success: (model, response, options)=>
          e.target.reset()

          if parseInt(model.get('id')) == parseInt($.cookie('id'))
            App.ventFunctions.updateLocalUser()

          # Creating user from user list page
          if !@uid and @options.front_view
            @options.front_view.model = model
            @options.front_view.render().$el.show()
            @remove()
            App.execute 'message',
              type: 'success'
              text: _.t 'user created'
            return

          # Updating user from user list page
          if @uid and @options.front_view
            @options.front_view.model = model
            @options.front_view.render().$el.show()
            @remove()
            App.execute 'message',
              type: 'success'
              text: _.t 'user updated', model.get('username')
            return

          # Updating profile
          if @uid and !@options.front_view
            App.execute 'message',
              type: 'success'
              text: _.t 'your profile updated'

            App.navigate ''
            return

          # Register new user
          if !@uid
            loginCredentials = {username: model.get('username'),password: model.get('password')}

            App.ajax
              type: 'post'
              url: '/user/login'
              data: JSON.stringify(loginCredentials)
              success: (data)->
                LoginView.prototype.loginUser(data)
                App.execute 'message',
                  type: 'success'
                  text: _.t('welcome aboard')

    cancelEdit: (e)->
      e.preventDefault()

      if !@options.front_view
        return App.navigate ''

      if @options.front_view and @uid
        @options.front_view.$el.show()
      else
        @options.front_view.$el.remove()

      @remove()

  UserFormView
