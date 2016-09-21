class CodecovController
  constructor: ({@codecovService}) ->
    throw new Error 'Missing codecovService' unless @codecovService?

  webhookMocha: (req, res) =>
    { owner_name, repo_name } = req.params
    body = req.body
    body.owner_name = owner_name
    body.repo_name = repo_name
    @codecovService.webhook { type: 'mocha', body }, (error) =>
      return res.sendError(error) if error?
      res.sendStatus(200)

  webhookCodecovIO: (req, res) =>
    body = req.body
    @codecovService.webhook { type: 'codecov.io', body }, (error) =>
      return res.sendError(error) if error?
      res.sendStatus(200)

module.exports = CodecovController
