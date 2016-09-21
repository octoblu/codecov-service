class CodecovController
  constructor: ({@codecovService}) ->
    throw new Error 'Missing codecovService' unless @codecovService?

  upload: (req, res) =>
    { owner_name, repo_name } = req.params
    body = req.body
    @codecovService.upload { owner_name, repo_name, body }, (error) =>
      return res.sendError(error) if error?
      res.sendStatus(200)

  webhookCodecovIO: (req, res) =>
    body = req.body
    @codecovService.webhook { type: 'codecov.io', body }, (error) =>
      return res.sendError(error) if error?
      res.sendStatus(200)

module.exports = CodecovController
