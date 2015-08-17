define [
  'marionette'
], (Mn)->
  Sort = Mn.Behavior.extend
    initialize: (options)->
      @options = options || {}

    ui:
      select: '#sort'

    events:
      'change @ui.select': 'sortList'

    sortList: (e)->
      _val = $(e.target).val()
      @view.collection.comparator = _val
      @view.collection.sort()

  Sort
