
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

  dimension: epic_link {
    type: number
    hidden: yes
    sql: ${TABLE}.epic_link ;;
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

  dimension: nps {
    label: "NPS"
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.net_promoter_score ;;
  }

  measure: average_nps {
    type: average
    label: "Average NPS"
    value_format_name: decimal_1
    sql: ${TABLE}.net_promoter_score ;;
  }

  measure: min_nps {
    type: min
    value_format_name: decimal_0
    label: "Minimum NPS"
    sql: ${TABLE}.net_promoter_score ;;
  }

  measure: max_nps {
    type: max
    value_format_name: decimal_0
    label: "Maximum NPS"
    sql: ${TABLE}.net_promoter_score ;;
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

  dimension: client_name {
    type: string
    label: "Client"
    sql:  ${TABLE}.client_name;;
  }

  # Additional field for a simple way to determine
  # if an issue is resolved
  dimension: is_issue_resolved {
    type: yesno
    label: "Is resolved"
    sql: ${resolved_date} IS NOT NULL ;;
  }

  dimension_group: duration_resolved {
    type: duration
    label: "Resolve duration"
    intervals: [hour,day,week,month]
    sql_start:${TABLE}.created  ;;
    sql_end:  ${TABLE}.resolved ;;

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

  dimension: summary {
    type: string
    label: "Summary"
    sql: ${TABLE}.summary ;;
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
  }

  measure: count_open {
    type: count
    label: "Open issue count"
    filters: [is_issue_resolved: "no"]
  }

  measure: count_resolved {
    type: count
    label: "Resolved issue count"
    filters: [is_issue_resolved: "yes"]
  }

  # ----- Sets of fields for drilling ------
  #set: detail {
  #  fields: [
  #    external_issue_id,
  #  ]
  #}

}
