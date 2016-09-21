class CodecovService
  constructor: ({@db}) ->

  upload: ({owner_name, repo_name, body}, callback) =>
    @db.metrics.update {owner_name, repo_name}, {owner_name, repo_name, body}, upsert: true, callback

  webhook: ({body}, callback) =>
    @db.webhooks.insert {body}, callback

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = CodecovService
