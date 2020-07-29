view: issue {
  sql_table_name: issue ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    hidden: yes
    sql: ${TABLE}._fivetran_synced ;;
  }

  dimension: external_issue_id {
    type: string
    label: "External issue id"
    sql: ${TABLE}.external_issue_id ;;
  }

  dimension:_original_estimate {
    type: number
    label: "Original estimate (hours)"
    sql: ${TABLE}.original_estimate / 3600;;
  }

  measure: sum_original_estimate {
    type: sum
    value_format_name: decimal_0
    label: "Original estimate (hours)"
    sql:  ${TABLE}.original_estimate / 3600;;
  }

  measure: average_original_estimate {
    type: average
    value_format_name: decimal_0
    label: "Average original estimate (hours)"
    sql:  ${TABLE}.original_estimate / 3600;;
    }

  dimension: remaining_estimate {
    type: number
    value_format_name: decimal_0
    label: "Remaining estimate (hours)"
    sql: ${TABLE}.remaining_estimate / 3600;;
  }

  measure: sum_remaining_estimate {
    type: sum
    value_format_name: decimal_0
    label: "Remaining estimate (hours)"
    sql:  ${TABLE}.remaining_estimate / 3600 ;;
  }

  measure: average_remaining_estimate {
    type: average
    value_format_name: decimal_0
    label: "Average remaining estimate (hours)"
    sql:  ${TABLE}.remaining_estimate / 3600;;
  }

  dimension: time_spent {
    type: number
    value_format_name: decimal_0
    label: "Time spent (hours)"
    sql: ${TABLE}.time_spent / 3600;;
  }

  measure: sum_time_spent {
    type: sum
    value_format_name: decimal_0
    label: "Time spent (hours)"
    sql:  ${TABLE}.time_spent / 3600 ;;
  }

  measure: average_time_spent {
    type: average
    value_format_name: decimal_0
    label: "Average time spent (hours)"
    sql:  ${TABLE}.time_spent / 3600 ;;
  }

  dimension: assignee {
    type: string
    sql: ${TABLE}.assignee ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created ;;
  }

  dimension: department {
    hidden: yes
    type: number
    sql: ${TABLE}.op_department ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension_group: due {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: ${TABLE}.due_date ;;
  }

  dimension: environment {
    type: string
    sql: ${TABLE}.environment ;;
  }

  dimension: issue_type {
    hidden: yes
    type: number
    sql: ${TABLE}.issue_type ;;
  }

  dimension: key {
    label: "Key"
    type: string
    sql: ${TABLE}.key ;;
    }

  dimension: priority {
    type: number
    hidden: yes
    sql: ${TABLE}.priority ;;
  }

  dimension: project {
    label: "Current Project"
    hidden: yes
    type: number
    sql: ${TABLE}.project ;;
  }

  dimension: resolution {
    group_label: "Resolution"
    hidden: yes
    type: number
    sql: ${TABLE}.resolution ;;
  }

  dimension_group: resolved {
    label: "Resolved"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.resolved ;;
  }

  # Additional field for a simple way to determine
  # if an issue is resolved
  dimension: is_issue_resolved {
    type: yesno
    label: "Is resolved"
    sql: ${resolved_date} IS NOT NULL ;;
  }

  # Custom dimensions for time to resolve issue
  dimension: hours_to_resolve_issue {
    label: "Time to Resolve (Hours)"
    type: number
    sql: DATEDIFF(h,${created_raw},${resolved_raw}) ;;
    value_format_name: decimal_0
  }

  dimension: days_to_resolve_issue {
    label: "Time to Resolve (Days)"
    type: number
    sql: DATEDIFF(d,${created_raw},${resolved_raw}) ;;
    value_format_name: decimal_0
  }

  measure: sum_duration_resolve {
    label: "Time to Resolve (hours)"
    description: "The total hours required to resolve all issues in the chosen dimension grouping"
    type: sum
    sql: ${days_to_resolve_issue} ;;
    value_format_name: decimal_0
  }

  measure: avg_time_to_resolve_issues_hours {
    label: "Average time to Resolve (hours)"
    description: "The average hours required to resolve all issues in the chosen dimension grouping"
    type: average
    sql: ${days_to_resolve_issue} ;;
    value_format_name: decimal_0
  }

  dimension: severity {
    hidden: yes
    type: number
    sql: ${TABLE}.severity ;;
  }

  dimension: status {
    hidden: yes
    type: number
    sql: ${TABLE}.status ;;
  }

  dimension: story_points {
    type: number
    sql: ${TABLE}.story_points ;;
  }

  measure: total_story_points {
    type: sum
    sql: ${story_points} ;;
  }

# # measure: total_open_story_points {
#    type: sum
#    sql: ${story_points} ;;
##    filters: {
#      field: status.name
#      value:"Open, In Progress, In Development, In QA, In Review"
#    }
#  }

#  measure: total_closed_story_points {
#    type: sum
#    sql: ${story_points} ;;
#    filters: {
#      field: status.name
#      value:"Closed, Done, Ready for Production"
#    }
#  }

  dimension_group: updated {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated ;;
  }

  measure: count {
    type: count
    label: "Issue count"
    drill_fields: [id, days_to_resolve_issue, created_date, severity ]
  }

  # ----- Sets of fields for drilling ------
  #set: detail {
  #  fields: [
  #    external_issue_id,
  #  ]
  #}

}
