CodecovController = require './controllers/codecov-controller'

class Router
  constructor: ({@codecovService}) ->
    throw new Error 'Missing codecovService' unless @codecovService?

  route: (app) =>
    codecovController = new CodecovController {@codecovService}

    app.post '/upload/:owner_name/:repo_name', codecovController.upload
    app.post '/webhooks/codecov.io', codecovController.webhook

module.exports = Router
