_             = require 'lodash'
shmock        = require 'shmock'
request       = require 'request'
enableDestroy = require 'server-destroy'
Server        = require '../../src/server'
mongojs       = require 'mongojs'

describe 'WallOfShame Metrics', ->
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

  describe 'On GET /metrics/wallofshame', ->
    beforeEach (done) ->
      metric =
        owner_name: "octoblu"
        repo_name: "meshblu-core-dispatcher"
        test_cases_count: 24
        passing_test_cases_count: 24
        failing_test_cases_count: 0
        pending_test_cases_count: 0
        test_cases_duration_ms: 25021
        total_lines_count: 232
        lines_covered_count: 50
        lines_missed_count: 48
        branches_covered_count: 8
        open_issues_count: 5
      @metrics.insert metric, done

    beforeEach (done) ->
      metric =
        owner_name: "octoblu"
        repo_name: "meshblu-core-something"
        test_cases_count: 26
        passing_test_cases_count: 24
        failing_test_cases_count: 0
        pending_test_cases_count: 0
        test_cases_duration_ms: 500
        total_lines_count: 22
        lines_covered_count: 1
        lines_missed_count: 1
        branches_covered_count: 8
        open_issues_count: null
      @metrics.insert metric, done

    beforeEach (done) ->
      userAuth = new Buffer('some-uuid:some-token').toString 'base64'

      options =
        uri: '/metrics/wallofshame'
        baseUrl: "http://localhost:#{@serverPort}"
        json: true

      request.get options, (error, @response, @body) =>
        done error

    it 'should return a 200', ->
      expect(@response.statusCode).to.equal 200

    it 'should return my record', ->
      expectedSummary = """
)-: Wall of Shame :-(
5% meshblu-core-something
22% meshblu-core-dispatcher
"""
      expect(@body).to.containSubset expectedSummary
