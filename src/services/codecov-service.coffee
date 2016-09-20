class CodecovService
  constructor: ({@datastore}) ->

  upload: ({owner_name, repo_name, body}, callback) =>
    @datastore.insert {owner_name, repo_name, body}, callback

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = CodecovService
