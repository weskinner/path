fuzzyFinderPath = atom.packages.resolvePackagePath('fuzzy-finder')

module.exports =

  activate: (state) ->
    atom.workspaceView.command 'path:relativeToMe', =>
      @createPathSelectorView().toggle()

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

  deactivate: ->


  serialize: ->
