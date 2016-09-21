CodecovController = require './controllers/codecov-controller'

class Router
  constructor: ({@codecovService}) ->
    throw new Error 'Missing codecovService' unless @codecovService?

  route: (app) =>
    codecovController = new CodecovController {@codecovService}

    app.post '/webhooks/mocha/:owner_name/:repo_name', codecovController.webhookMocha
    app.post '/webhooks/codecov.io', codecovController.webhookCodecovIO

module.exports = Router
