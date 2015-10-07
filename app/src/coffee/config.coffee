requirejs.config
  # urlArgs: "bust=" + (new Date()).getTime()

  shim:
    'jquery.cookie':
      deps: ['jquery']

    'jquery.hammer':
      deps: ['jquery', 'hammerjs']
      exports: 'hammer'

    'mandrill':
      exports: 'mandrill'

  paths:
    jquery: 'libs/jquery.min'
    underscore: 'libs/underscore-min'
    backbone: 'libs/backbone-min'
    text: 'libs/text'
    i18n: 'libs/i18n'
    localStorage: 'libs/backbone.localStorage-min'
    'jquery.cookie': 'libs/jquery.cookie'
    'moment': 'libs/moment.min'
    'marked': 'libs/marked.min'
    'hammerjs': 'libs/hammer.min'
    'jquery.hammer': 'libs/jquery.hammer'
    'mandrill': 'libs/mandrill.min'
    'marionette': "libs/backbone.marionette.min"

  deps: ['main']
