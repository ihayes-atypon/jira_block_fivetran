
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

  dimension_group: created_to_now {
    label: "Created to now"
    type: duration
    intervals: [hour,day,week,month]
    sql_start:${TABLE}.created  ;;
    sql_end:  now() ;;
  }

  dimension: creator {
    type: string
    label: "Creator"
    hidden: yes
    sql: ${TABLE}.creator ;;
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
    label: "Resolved"
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

  dimension:archiver{
    type: string
    label: "Archiver"
    sql: ${TABLE}.archiver;;
  }

  dimension_group: archived {
    type: time
    label: "Archived"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.archived ;;
  }

  dimension: incident_trigger_source {
    type: string
    label: "Incident trigger source"
    sql: ${TABLE}.incident_trigger_source ;;
  }

  dimension: incident_trigger {
    type: string
    label: "Incident trigger"
    sql: ${TABLE}.incident_trigger ;;
  }

  dimension: teams {
    type: string
    label: "Teams"
    sql: ${TABLE}.teams ;;
  }

  dimension: sa_owner {
    type: string
    label: "SA owner"
    sql: ${TABLE}.sa_owner ;;
  }

  dimension: survey_updated {
    type: string
    label: "Survey updated"
    sql: ${TABLE}.survey_updated ;;
  }

  dimension_group: mar_updated {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    label: "Market awareness updated"
    sql: ${TABLE}.mar_updated ;;
  }

  dimension: market_awareness_results {
    type: number
    label: "Market awareness results"
    sql: ${TABLE}.market_awareness_results ;;
  }

  dimension: jira_customer_satisfaction_survey {
    type: number
    label: "Jira customer satisfactioin survey"
    sql: ${TABLE}.jira_customer_satisfaction_survey ;;
  }

  dimension: ui_type {
    type: number
    label: "UI type"
    sql: ${TABLE}.ui_type ;;
  }

  dimension: test_case_automation {
    type: number
    label: "Test case automation"
    sql: ${TABLE}.test_case_automation ;;
  }

  dimension: team_type {
    type: number
    label: "Team type"
    sql: ${TABLE}.team_type ;;
  }

  dimension: subjective_client_rating {
    type: number
    label: "Subjective client rating"
    sql: ${TABLE}.subjective_client_rating ;;
  }

  dimension: status_meeting_frequency {
    type: number
    label: "Status meeting frequency"
    sql: ${TABLE}.status_meeting_frequency ;;
  }

  dimension_group: sh_updated {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    label: "SH updated"
    sql: ${TABLE}.sh_updated ;;
  }

  dimension_group: nps_updated {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    label: "NPS updated"
    sql: ${TABLE}.nps_updated ;;
  }

  dimension: net_promoter_score {
    type: number
    label: "Net promoter score"
    sql: ${TABLE}.net_promoter_score ;;
  }

  dimension: hotline_customer {
    type: number
    label: "Hotline customer"
    sql: ${TABLE}.hotline_customer ;;
  }

  dimension: financial_health {
    type: number
    label: "Financial health"
    sql: ${TABLE}.financial_health ;;
  }

  dimension_group: fh_updated {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    label: "FH updated"
    sql: ${TABLE}.fh_updated ;;
  }

  dimension: escalations {
    type: string
    label: "Escalations"
    sql: ${TABLE}.escalations ;;
  }

  dimension: customfield_10202 {
    type: number
    label: "customfield_10202"
    sql: ${TABLE}.customfield_10202 ;;
  }

  dimension: company_type {
    type: string
    label: "Company type"
    sql: ${TABLE}.company_type ;;
  }

  dimension: client_location {
    type: string
    label: "Client location"
    sql: ${TABLE}.client_location ;;
  }

  dimension: client_confluence_space {
    type: string
    label: "Client_confluence space"
    sql: ${TABLE}.client_confluence_space ;;
  }

  dimension: backup_assignee_csr_am {
    type: string
    label: "backup assignee csr am"
    sql: ${TABLE}.backup_assignee_csr_am ;;
  }

  dimension: account_review_frequency {
    type: number
    label: "Account review frequency"
    sql: ${TABLE}.account_review_frequency ;;
  }

  dimension: sequence {
    type: number
    label: "Sequence"
    sql: ${TABLE}.sequence ;;
  }

  dimension: root_cause {
    type: number
    label: "Root cause"
    hidden: yes
    sql: ${TABLE}.root_cause ;;
  }

  dimension: atypon_lead {
    type: string
    label: "Atypon lead"
    sql: ${TABLE}.atypon_lead ;;
  }

}
