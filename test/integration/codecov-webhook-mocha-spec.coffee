shmock        = require 'shmock'
request       = require 'request'
enableDestroy = require 'server-destroy'
Server        = require '../../src/server'
mongojs       = require 'mongojs'


describe 'Webhook mocha', ->
  beforeEach (done) ->
    @db = mongojs 'test-codecov-service', ['webhooks']
    @webhooks = @db.webhooks
    @webhooks.remove done

  beforeEach (done) ->
    @meshblu = shmock 0xd00d
    enableDestroy @meshblu

    @logFn = sinon.spy()
    serverOptions =
      port: undefined,
      disableLogging: true
      logFn: @logFn
      mongodbUri: 'test-codecov-service'
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

  describe 'On POST /webhooks/mocha', ->
    beforeEach (done) ->
      userAuth = new Buffer('some-uuid:some-token').toString 'base64'

      options =
        uri: '/webhooks/mocha/octoblu/sample-project'
        baseUrl: "http://localhost:#{@serverPort}"
        json: blah: 'blah'

      request.post options, (error, @response, @body) =>
        done error

    it 'should return a 200', ->
      expect(@response.statusCode).to.equal 200

    it 'should insert the json into the project', (done) ->
      @webhooks.findOne type: 'mocha', (error, result) =>
        expect(result).to.exist
        expectedBody =
          owner_name: 'octoblu'
          repo_name: 'sample-project'
          blah: 'blah'
        expect(result.body).to.deep.equal expectedBody
        done()
