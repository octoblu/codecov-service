enableDestroy      = require 'server-destroy'
octobluExpress     = require 'express-octoblu'
express            = require 'express'
MeshbluAuth        = require 'express-meshblu-auth'
Router             = require './router'
CodecovService     = require './services/codecov-service'
debug              = require('debug')('codecov-service:server')

class Server
  constructor: ({@logFn, @disableLogging, @port, @meshbluConfig})->
    throw new Error 'Missing meshbluConfig' unless @meshbluConfig?

  address: =>
    @server.address()

  run: (callback) =>
    app = octobluExpress({ @logFn, @disableLogging })

    meshbluAuth = new MeshbluAuth @meshbluConfig
    app.use express.static 'public'

    app.use meshbluAuth.auth()
    app.use meshbluAuth.gateway()

    codecovService = new CodecovService
    router = new Router {@meshbluConfig, codecovService}

    router.route app

    @server = app.listen @port, callback
    enableDestroy @server

  stop: (callback) =>
    @server.close callback

  destroy: =>
    @server.destroy()

module.exports = Server
