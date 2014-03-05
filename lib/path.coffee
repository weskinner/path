fuzzyFinderPath = atom.packages.resolvePackagePath('fuzzy-finder')
path = require 'path'

module.exports =

  activate: (state) ->
    atom.workspaceView.command 'path:insert-relative-to-me', =>
      @createPathSelectorView().promptForPath @insertRelativeToMe
    atom.workspaceView.command 'path:insert-full-path', =>
      @createPathSelectorView().promptForPath @insertAbsolute

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

  deactivate: ->


  serialize: ->
