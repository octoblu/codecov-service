_             = require 'lodash'
shmock        = require 'shmock'
request       = require 'request'
enableDestroy = require 'server-destroy'
Server        = require '../../src/server'
mongojs       = require 'mongojs'

describe 'Healthcheck', ->
  beforeEach (done) ->
    db = mongojs 'test-codecov-service', ['metrics']
    @metrics = db.metrics
    db.metrics.remove done

  describe 'On GET /proofoflife', ->
    context 'writable redis', ->
      beforeEach (done) ->
        @logFn = sinon.spy()
        serverOptions =
          port: undefined,
          disableLogging: true
          logFn: @logFn
          mongodbUri: 'test-codecov-service'
          redisUri: 'redis://localhost'
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
        @server.destroy()

      beforeEach (done) ->
        options =
          uri: '/proofoflife'
          baseUrl: "http://localhost:#{@serverPort}"
          json: true

        request.get options, (error, @response, @body) =>
          done error

      it 'should return a 200', ->
        expect(@response.statusCode).to.equal 200

      it 'should return online: true', ->
        expect(@body).to.deep.equal online: true

    context 'unwritable redis', ->
      beforeEach (done) ->
        @logFn = sinon.spy()
        serverOptions =
          port: undefined,
          disableLogging: true
          logFn: @logFn
          mongodbUri: 'test-codecov-service'
          redisUri: 'redis://localhost:4000'
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
        @server.destroy()

      beforeEach (done) ->
        options =
          uri: '/proofoflife'
          baseUrl: "http://localhost:#{@serverPort}"
          json: true

        request.get options, (error, @response, @body) =>
          done error

      it 'should return a 500', ->
        expect(@response.statusCode).to.equal 500

      it 'should return error', ->
        expect(@body).to.deep.equal error: "Stream isn't writeable and enableOfflineQueue options is false"

    context 'writable mongo', ->
      beforeEach (done) ->
        @logFn = sinon.spy()
        serverOptions =
          port: undefined,
          disableLogging: true
          logFn: @logFn
          mongodbUri: 'test-codecov-service'
          redisUri: 'redis://localhost'
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
        @server.destroy()

      beforeEach (done) ->
        options =
          uri: '/proofoflife'
          baseUrl: "http://localhost:#{@serverPort}"
          json: true

        request.get options, (error, @response, @body) =>
          done error

      it 'should return a 200', ->
        expect(@response.statusCode).to.equal 200

      it 'should return online: true', ->
        expect(@body).to.deep.equal online: true

    context.only 'unwritable mongo', ->
      beforeEach (done) ->
        @logFn = sinon.spy()
        serverOptions =
          port: undefined,
          disableLogging: true
          logFn: @logFn
          mongodbUri: 'test/mydb'
          redisUri: 'redis://localhost'
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
        @server.destroy()

      beforeEach (done) ->
        options =
          uri: '/proofoflife'
          baseUrl: "http://localhost:#{@serverPort}"
          json: true

        request.get options, (error, @response, @body) =>
          done error

      it 'should return a 500', ->
        expect(@response.statusCode).to.equal 500

      it 'should return error', ->
        expect(@body.error).to.exist
