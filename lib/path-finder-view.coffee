{SelectListView} = require 'atom'

module.exports =
class PathFinderView extends SelectListView
  initialize: () ->
    super
    @addClass('overlay from-top')
    @setItems(['Apple', 'Orange', 'Banana'])
    atom.workspaceView.append(this)
    @focusFilterEditor()

  viewForItem: (item) ->
    "<li>#{item}</li>"

  confirmed: (item) ->
    console.log("#{item} was selected")
