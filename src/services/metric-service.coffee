class MetricService
  constructor: ({@db}) ->
    @datastore = @db.metrics

  list: (callback) =>
    @datastore.find {}, {'_id': false}, callback

module.exports = MetricService
