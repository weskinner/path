fuzzyFinderPath = atom.packages.resolvePackagePath('fuzzy-finder')
ProjectView  = require fuzzyFinderPath + '/lib/project-view'
fs = require 'fs'
path = require 'path'

module.exports =
class PathSelectorView extends ProjectView

  promptForPath: (@pathSelected) ->
    @toggle()

  confirmed : ({filePath}) ->
    @cancel()
    @pathSelected(filePath)
