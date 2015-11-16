define [
  'marionette'
  'env'
], (Mn, ENV)->
  App = new Mn.Application()

  App.url = (_url)->
    'http://' + ENV.prod_ip + ':5000' + _url

  App.ajax = (options)->
    $.ajax
      type: options.type
      url: @url options.url
      data: options.data
      crossDomain: true
      contentType: "application/json; charset=utf-8"
      success: options.success

  App
