fuzzyFinderPath = atom.packages.resolvePackagePath('fuzzy-finder')
ProjectView  = require fuzzyFinderPath + '/lib/project-view'
fs = require 'fs'
path = require 'path'

module.exports =
class PathSelectorView extends ProjectView

  confirmed : ({filePath}) ->
    return unless filePath

    else
      lineNumber = @getLineNumber()
      @cancel()
      activeEditor = atom.workspace.getActiveEditor()
      if activeEditor?
        activeEditorUri = atom.workspace.getActiveEditor().getUri()
        relativePath = path.relative(path.dirname(activeEditorUri), filePath)
        activeEditor.insertText(relativePath)
