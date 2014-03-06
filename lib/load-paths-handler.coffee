fs = require 'fs'
path = require 'path'
_ = require 'underscore-plus'
{Git} = require 'atom'

asyncCallsInProgress = 0
pathsChunkSize = 100
paths = []
repo = null
ignoredNames = null
callback = null

isIgnored = (loadedPath) ->
  if repo?.isPathIgnored(loadedPath)
    true
  else
    name = path.basename(loadedPath)
    return true if _.indexOf(ignoredNames, name, true) isnt -1

    if extension = path.extname(name)
      return true if  _.indexOf(ignoredNames, "*#{extension}", true) isnt -1

asyncCallStarting = ->
  asyncCallsInProgress++

asyncCallDone = ->
  if --asyncCallsInProgress is 0
    repo?.destroy()
    emit('load-paths:paths-found', paths)
    callback()

pathLoaded = (path) ->
  paths.push(path) unless isIgnored(path)
  if paths.length is pathsChunkSize
    emit('load-paths:paths-found', paths)
    paths = []

loadPath = (path) ->
  asyncCallStarting()
  fs.lstat path, (error, stats) ->
    unless error?
      if stats.isSymbolicLink()
        asyncCallStarting()
        fs.stat path, (error, stats) ->
          unless error?
            pathLoaded(path) if stats.isFile()
          asyncCallDone()
      else if stats.isDirectory()
        pathLoaded(path)
        loadFolder(path) unless isIgnored(path)
      else if stats.isFile()
        pathLoaded(path)
    asyncCallDone()

loadFolder = (folderPath) ->
  asyncCallStarting()
  fs.readdir folderPath, (error, children=[]) ->
    loadPath(path.join(folderPath, childName)) for childName in children
    asyncCallDone()

module.exports = (rootPath, ignoreVcsIgnores, ignore) ->
  ignoredNames = ignore
  callback = @async()
  repo = Git.open(rootPath, refreshOnWindowFocus: false) if ignoreVcsIgnores
  ignoredNames.sort()
  loadFolder(rootPath)
