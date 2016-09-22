_             = require 'lodash'
shmock        = require 'shmock'
request       = require 'request'
enableDestroy = require 'server-destroy'
Server        = require '../../src/server'
mongojs       = require 'mongojs'

describe 'Get Metrics', ->
  beforeEach (done) ->
    db = mongojs 'test-codecov-service', ['metrics']
    @metrics = db.metrics
    db.metrics.remove done

  beforeEach (done) ->
    @meshblu = shmock 0xd00d
    enableDestroy @meshblu

    @logFn = sinon.spy()
    serverOptions =
      port: undefined,
      disableLogging: true
      logFn: @logFn
      mongodbUri: 'test-codecov-service'
      redisUri: 'localhost'
      redisNamespace: 'test-codecov'
      meshbluConfig:
        hostname: 'localhost'
        protocol: 'http'
        resolveSrv: false
        port: 0xd00d

    @server = new Server serverOptions

    @server.run =>
      @serverPort = @server.address().port
      done()

  afterEach ->
    @meshblu.destroy()
    @server.destroy()

  describe 'On GET /metrics', ->
    beforeEach (done) ->
      @metrics.insert owner_name: 'foo', repo_name: 'bar', some_metric: 1.87, done

    beforeEach (done) ->
      userAuth = new Buffer('some-uuid:some-token').toString 'base64'

      options =
        uri: '/metrics'
        baseUrl: "http://localhost:#{@serverPort}"
        json: true

      request.get options, (error, @response, @body) =>
        done error

    it 'should return a 200', ->
      expect(@response.statusCode).to.equal 200

    it 'should return an array of metrics', ->
      expect(@body).to.exist

    it 'should return my record', ->
      expect(_.first @body).to.containSubset some_metric: 1.87
