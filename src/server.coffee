enableDestroy      = require 'server-destroy'
octobluExpress     = require 'express-octoblu'
express            = require 'express'
MeshbluAuth        = require 'express-meshblu-auth'
Router             = require './router'
WebhookService     = require './services/webhook-service'
debug              = require('debug')('codecov-service:server')
mongojs            = require 'mongojs'

class Server
  constructor: ({@logFn, @disableLogging, @port, @meshbluConfig, @mongodbUri})->
    throw new Error 'Server requires: meshbluConfig' unless @meshbluConfig?
    throw new Error 'Server requires: mongodbUri' unless @mongodbUri?

  address: =>
    @server.address()

  run: (callback) =>
    app = octobluExpress({ @logFn, @disableLogging })

    meshbluAuth = new MeshbluAuth @meshbluConfig
    app.use express.static 'public'

    # app.use meshbluAuth.auth()
    # app.use meshbluAuth.gateway()

    db = mongojs @mongodbUri, ['metrics', 'webhooks']
    webhookService = new WebhookService {db}
    router = new Router {@meshbluConfig, webhookService, db}

    router.route app

    @server = app.listen @port, callback
    enableDestroy @server

  stop: (callback) =>
    @server.close callback

  destroy: =>
    @server.destroy()

module.exports = Server
