enableDestroy      = require 'server-destroy'
octobluExpress     = require 'express-octoblu'
express            = require 'express'
MeshbluAuth        = require 'express-meshblu-auth'
Router             = require './router'
WebhookService     = require './services/webhook-service'
MetricService      = require './services/metric-service'
debug              = require('debug')('codecov-service:server')
mongojs            = require 'mongojs'
Redis              = require 'ioredis'
RedisNS            = require '@octoblu/redis-ns'

class Server
  constructor: (options={})->
    {
      @logFn
      @disableLogging
      @port
      @meshbluConfig
      @mongodbUri
      @redisNamespace
      @redisUri
    } = options
    throw new Error 'Server requires: meshbluConfig' unless @meshbluConfig?
    throw new Error 'Server requires: mongodbUri' unless @mongodbUri?
    throw new Error 'Server requires: redisUri' unless @redisUri?
    throw new Error 'Server requires: redisNamespace' unless @redisNamespace?

  address: =>
    @server.address()

  run: (callback) =>
    app = octobluExpress({ @logFn, @disableLogging })

    meshbluAuth = new MeshbluAuth @meshbluConfig
    app.use express.static 'public'

    # app.use meshbluAuth.auth()
    # app.use meshbluAuth.gateway()

    db = mongojs @mongodbUri, ['metrics', 'webhooks']
    db.on 'error', @panic

    client = new Redis @redisUri, dropBufferSupport: true, enableOfflineQueue: false
    client.on 'error', @panic
    client.on 'ready', =>
      redis = new RedisNS @redisNamespace, client

      app.use '/proofoflife', (req, res, next) =>
        client.set 'test:write', Date.now(), (error) =>
          return res.sendError error if error
          db.runCommand {ping: 1}, (error) =>
            return res.sendError error if error
            res.send online: true

      webhookService = new WebhookService { redis }
      metricService = new MetricService { db }
      router = new Router { metricService, webhookService }

      router.route app

      @server = app.listen @port, callback
      enableDestroy @server

  stop: (callback) =>
    @server.close callback

  destroy: =>
    @server.destroy()

  panic: (error) =>
    console.error error.stack
    process.exit 1

module.exports = Server
