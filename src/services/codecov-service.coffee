class CodecovService
  constructor: ({@datastore}) ->

  upload: ({owner_name, repo_name, body}, callback) =>
    @datastore.update {owner_name, repo_name}, {owner_name, repo_name, body}, upsert: true, callback

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = CodecovService
