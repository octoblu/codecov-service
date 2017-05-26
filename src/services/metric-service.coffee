_ = require 'lodash'

class MetricService
  constructor: ({@db}) ->
    @datastore = @db.metrics

  list: (callback) =>
    @datastore.find {}, {'_id': false}, callback

  summary: (callback) =>
    @_summary callback

  scorecard: (callback) =>
    @_summary (error, summary) =>
      return callback error if error?
      {
        coverage_ratio,
        defect_density,
        test_cases_duration_ms,
        test_cases_automated,
        test_cases_count,
        lines_covered_count,
      } = summary

      build_time_minutes = ((test_cases_duration_ms / 1000) / 60).toFixed(2)
      scorecard = """
Quality Dashboard:
Lines Covered:                 #{lines_covered_count}
Code Coverage:                 #{coverage_ratio}%
Test Cases:                    #{test_cases_count}
Test Cases automated:          #{test_cases_automated}%
Build Time (minutes):          #{build_time_minutes}
Full test pass time (minutes): #{build_time_minutes}
Defect Density:                #{defect_density}
"""
      callback null, scorecard

  _summary: (callback) =>
    @datastore.find {}, {'_id': false}, (error, data) =>
      return callback error if error?

      summary =
        test_cases_automated: ""
        passing_test_cases_count: 0
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
        summary.passing_test_cases_count += datum.passing_test_cases_count ? 0

      if summary.total_lines_count > 0
        summary.coverage_ratio = ((summary.lines_covered_count / summary.total_lines_count) * 100).toFixed(2)
        summary.defect_density = (summary.open_issues_count / summary.total_lines_count).toFixed(2)

      if summary.test_cases_count > 0
        summary.test_cases_automated = ((summary.passing_test_cases_count / summary.test_cases_count) * 100).toFixed(2)

      return callback null, summary

  wallofshame: (callback) =>
    shamecard = """
)-: Wall of Shame :-(
"""
    @datastore.find {}, {'_id': false}, (error, data) =>
      return callback error if error?
      data = _.filter data, (datum) =>
        { lines_covered_count, total_lines_count } = datum
        lines_covered_count ?= 0
        total_lines_count ?= 0
        datum.coverage_ratio = 0
        return true if total_lines_count == 0
        datum.coverage_ratio = (lines_covered_count / datum.total_lines_count) * 100
        return datum.coverage_ratio < 30

      sortedShame = _.sortBy data, 'coverage_ratio'
      _.each sortedShame, (datum) =>
        shamecard += "\n#{datum.coverage_ratio.toFixed(0)}% #{datum.repo_name}"

      return callback null, shamecard

module.exports = MetricService
