fuzzyFinderPath = atom.packages.resolvePackagePath('fuzzy-finder')
path = require 'path'

module.exports =

  activate: (state) ->
    atom.workspaceView.command 'path:insert-relative-to-me', =>
      @createPathSelectorView().promptForPath @insertRelativeToMe
    atom.workspaceView.command 'path:insert-full-path', =>
      @createPathSelectorView().promptForPath @insertAbsolute
    atom.workspaceView.command 'path:pull-up', =>
      @pullUp()
    atom.workspaceView.command 'path:insert-relative-to', () =>
      @createPathFinderView()

    if atom.project.getPath()?
      PathLoader = require fuzzyFinderPath + '/lib/path-loader'
      @loadPathsTask = PathLoader.startTask (paths) => @projectPaths = paths

  createPathSelectorView: ->
    unless @projectView?
      @loadPathsTask?.terminate()
      PathSelectorView  = require './path-selector-view'
      @projectView = new PathSelectorView(@projectPaths)
      @projectPaths = null
    @projectView

  createPathFinderView: () ->
    unless @pathFinderView?
      PathFinderView = require './path-finder-view.coffee'
      @pathFinderView = new PathFinderView()
    @pathFinderView

  insertRelativeToMe: (filePath) ->
    activeEditor = atom.workspace.getActiveEditor()
    if activeEditor?
      activeEditorUri = atom.workspace.getActiveEditor().getUri()
      relativePath = path.relative(path.dirname(activeEditorUri), filePath)
      activeEditor.insertText(relativePath)

  insertAbsolute: (filePath) ->
    activeEditor = atom.workspace.getActiveEditor()
    if activeEditor?
      activeEditor.insertText(filePath)

  pullUp: ->
    activeEditor = atom.workspace.getActiveEditor()
    if activeEditor?
      selectedText = activeEditor.getSelectedText()
      if selectedText?
        basename = path.basename(selectedText)
        pulledText = path.join(selectedText, '..', '..')
        result = path.join(pulledText, basename)
        activeEditor.insertText(result)
        cursorPoint = activeEditor.getCursorBufferPosition().toArray()
        startOfResult = [cursorPoint[0], cursorPoint[1] - result.length]
        activeEditor.addSelectionForBufferRange([startOfResult,cursorPoint])

  deactivate: ->


  serialize: ->
