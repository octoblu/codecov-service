_ = require 'lodash'

class MetricService
  constructor: ({@db}) ->
    @datastore = @db.metrics

  list: (callback) =>
    @datastore.find {}, {'_id': false}, callback

  summary: (callback) =>
    @datastore.find {}, {'_id': false}, (error, data) =>
      return callback error if error?

      summary =
        total_lines_count: 0
        lines_covered_count: 0
        lines_missed_count: 0
        test_cases_count: 0
        open_issues_count: 0
        coverage_ratio: ""
        defect_density: 0
        test_cases_duration_ms: 0
        project_count: _.size data

      _.each data, (datum) =>
        summary.total_lines_count += datum.total_lines_count ? 0
        summary.lines_covered_count += datum.lines_covered_count ? 0
        summary.lines_missed_count += datum.lines_missed_count ? 0
        summary.test_cases_count += datum.test_cases_count ? 0
        summary.open_issues_count += datum.open_issues_count ? 0
        summary.test_cases_duration_ms += datum.test_cases_duration_ms ? 0

      if summary.total_lines_count > 0
        summary.coverage_ratio = ((summary.lines_covered_count / summary.total_lines_count) * 100).toFixed(2)
        summary.defect_density = (summary.open_issues_count / summary.total_lines_count).toFixed(2)

      return callback null, summary

module.exports = MetricService
