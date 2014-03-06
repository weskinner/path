{SelectListView, $$, $} = require 'atom'
humanize = require 'humanize-plus'
path = require 'path'
fs = require 'fs-plus'

PathLoader = require './path-loader'

module.exports =
class PathFinderView extends SelectListView
  paths: null
  reloadPaths: true

  initialize: (@paths) ->
    super

    @addClass('path-finder overlay from-top')
    @setMaxItems(10)

    @reloadPaths = false if @paths?.length > 0

    @subscribe $(window), 'focus', =>
      @reloadPaths = true
    @subscribe atom.config.observe 'fuzzy-finder.ignoredNames', callNow: false, =>
      @reloadPaths = true

  promptForPath: (@pathSelected) ->
    @toggle()

  toggle: ->
    if @hasParent()
      @cancel()
    else if atom.project.getPath()?
      @populate()
      @attach()

  confirmed : ({filePath}) ->
    @cancel()
    @pathSelected(filePath)

  attach: ->
    @storeFocusedElement()
    atom.workspaceView.append(this)
    @focusFilterEditor()

  getEmptyMessage: (itemCount) ->
    if itemCount is 0
      'Project is empty'
    else
      super

  populate: ->
    if @paths?
      @setItems(@paths)

    if @reloadPaths
      @reloadPaths = false
      @loadPathsTask?.terminate()
      @loadPathsTask = PathLoader.startTask (@paths) => @populate()

      if @paths?
        @setLoading("Reindexing project\u2026")
      else
        @setLoading("Indexing project\u2026")
        @loadingBadge.text('0')
        pathsFound = 0
        @loadPathsTask.on 'load-paths:paths-found', (paths) =>
          pathsFound += paths.length
          @loadingBadge.text(humanize.intComma(pathsFound))

  setItems: (filePaths) ->
    # Don't regenerate project relative paths unless the file paths have changed
    if filePaths isnt @filePaths
      @filePaths = filePaths
      @projectRelativePaths = @filePaths.map (filePath) ->
        projectRelativePath = atom.project.relativize(filePath)
        {filePath, projectRelativePath}

    super(@projectRelativePaths)

  getFilterKey: ->
    'projectRelativePath'

  destroy: ->
    @cancel()
    @remove()

  viewForItem: ({filePath, projectRelativePath}) ->
    $$ ->
      @li =>
        @div projectRelativePath

  beforeRemove: ->
    @loadPathsTask?.terminate()
