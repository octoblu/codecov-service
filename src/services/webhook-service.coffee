class WebhookService
  constructor: ({@db}) ->

  create: ({type, owner_name, repo_name, body}, callback) =>
    @db.webhooks.insert {type, body, owner_name, repo_name}, callback

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = WebhookService
