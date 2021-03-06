requirejs.config
  <% if (env === 'dev') { %>
  urlArgs: "bust=" + (new Date()).getTime()
  <% }; %>

  shim:
    'jquery.cookie':
      deps: ['jquery']

    'jquery.hammer':
      deps: ['jquery', 'hammerjs']
      exports: 'hammer'

    'backbone':
      deps: ['jquery', 'underscore']

    'marionette':
      deps: ['backbone']

  paths:
    jquery: 'libs/jquery'
    underscore: 'libs/underscore'
    backbone: 'libs/backbone'
    text: 'libs/text'
    i18n: 'libs/i18n'
    localStorage: 'libs/backbone.localStorage'
    'jquery.cookie': 'libs/jquery.cookie'
    'moment': 'libs/moment'
    'marked': 'libs/marked'
    'hammerjs': 'libs/hammer'
    'jquery.hammer': 'libs/jquery.hammer'
    'marionette': "libs/backbone.marionette"
    'backbone.wreqr': 'libs/backbone.wreqr'
    'backbone.babysitter': 'libs/backbone.babysitter'
    'backbone.stickit': 'libs/backbone.stickit'
