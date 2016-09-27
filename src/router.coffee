MetricController  = require './controllers/metric-controller'
WebhookController = require './controllers/webhook-controller'

class Router
  constructor: ({ @metricService, @webhookService }) ->
    throw new Error 'Missing webhookService' unless @webhookService?
    throw new Error 'Missing metricService' unless @metricService?

  route: (app) =>
    webhookController = new WebhookController {@webhookService}
    metricController = new MetricController {@metricService}

    app.get '/metrics', metricController.list
    app.get '/metrics/summary', metricController.summary
    app.post '/webhooks/:type', webhookController.create
    app.post '/webhooks/:type/:owner_name/:repo_name', webhookController.create

module.exports = Router
