CodecovController = require './controllers/codecov-controller'

class Router
  constructor: ({@codecovService}) ->
    throw new Error 'Missing codecovService' unless @codecovService?

  route: (app) =>
    codecovController = new CodecovController {@codecovService}

    app.get '/hello', codecovController.hello
    # e.g. app.put '/resource/:id', someController.update

module.exports = Router
