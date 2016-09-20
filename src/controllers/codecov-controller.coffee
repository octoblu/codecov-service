class CodecovController
  constructor: ({@codecovService}) ->
    throw new Error 'Missing codecovService' unless @codecovService?

  hello: (request, response) =>
    {hasError} = request.query
    @codecovService.doHello {hasError}, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(200)

module.exports = CodecovController
