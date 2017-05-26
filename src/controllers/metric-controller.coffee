class MetricController
  constructor: ({@metricService}) ->
    throw new Error 'Missing metricService' unless @metricService?

  list: (req, res) =>
    @metricService.list (error, data) =>
      return res.sendError(error) if error?
      res.status(200).send(data)

  summary: (req, res) =>
    @metricService.summary (error, data) =>
      return res.sendError(error) if error?
      res.status(200).send(data)

  scorecard: (req, res) =>
    @metricService.scorecard (error, data) =>
      return res.sendError(error) if error?
      res.status(200).send(data)

  wallofshame: (req, res) =>
    @metricService.wallofshame (error, data) =>
      return res.sendError(error) if error?
      res.status(200).send(data)

module.exports = MetricController
