connection: "jira-bigquery"

# include all the views
include: "../views/*.view"


datagroup: fivetran_datagroup {
  sql_trigger: SELECT max(date_trunc('minute', done)) FROM fivetran_audit ;;
  max_cache_age: "24 hours"
}

persist_with: fivetran_datagroup

# explore: looker_calendar {}

# explore: issue_extended {}

# explore: looker_numbers {}

# explore: user {}

explore: issue {
  label: "Issue"
  join:  issue_component_s {
    relationship: one_to_many
    sql_on: ${issue.id} = ${issue_component_s.issue_id} ;;
  }
  join: component {
    view_label: "Component"
    relationship: one_to_many
    fields: [component.name,component.description]
    sql_on: ${component.id} = ${issue_component_s.component_id} ;;
  }
  join: component_project {
    view_label: "Component"
    from: project
    relationship: many_to_one
    fields: [component_project.name]
    sql_on: ${component.project_id} = ${project.id} ;;
  }
  join: status {
    view_label: "Issue"
    relationship: many_to_one
    fields: [status.name]
    sql_on: ${issue.status} = ${status.id} ;;
  }
  join: status_category {
    view_label: "Issue"
    relationship: many_to_one
    fields: [status_category.name]
    sql_on: ${status.status_category_id} = ${status_category.id} ;;
  }
  join: priority {
    view_label: "Issue"
    relationship: many_to_one
    fields: [priority.name]
    sql_on: ${issue.priority} = ${priority.id} ;;
  }
  join: resolution {
    view_label: "Issue"
    relationship: many_to_one
    fields: [resolution.name]
    sql_on: ${issue.resolution} = ${resolution.id} ;;
  }
  join: worklog {
    view_label: "Work log"
    relationship: one_to_many
    sql_on: ${issue.id} = ${worklog.issue_id} ;;
  }
  join: issue_type {
    view_label: "Issue"
    relationship: many_to_one
    sql_on: ${issue.issue_type} = ${issue_type.id} ;;
  }
  join: project {
    view_label: "Project"
    relationship: many_to_one
    sql_on: ${issue.project} = ${project.id} ;;
  }
  join: project_category {
    view_label: "Project category"
    relationship: many_to_one
    sql_on: ${project.project_category_id} = ${project_category.id} ;;
  }
  join: comment {
    view_label: "Comment"
    relationship: one_to_many
    sql_on: ${issue.id} = ${comment.issue_id} ;;
  }
  join: comment_user {
    from: user
    view_label: "Comment"
    relationship: many_to_one
    fields: [comment_user.atypon_user]
    sql_on: ${comment.author_id} = ${comment_user.username} ;;
  }
  join: derived_issue_status_history {
    view_label: "Status history"
    relationship: one_to_many
    sql_on: ${issue.id} = ${derived_issue_status_history.issue_id} ;;
  }
  join: issue_labels {
    view_label: "Label"
    relationship: one_to_many
    sql_on: ${issue.id} = ${issue_labels.issue_id} ;;
  }

}


# explore: sprint {
#   join: issue_sprint {
#     type:  left_outer
#     sql_on: ${sprint.id} = ${issue_sprint.sprint_id} ;;
#     relationship: one_to_many
#   }
#   join: issue {
#     type:  left_outer
#     sql_on: ${issue_sprint.issue_id} = ${issue.id} ;;
#     relationship: one_to_many
#   }
#
# }

# Update based on how you are associating versions to
# explore: version {
#   join: issue_fix_version {
#     type: left_outer
#     relationship: one_to_many
#     sql_on: ${version.id} = ${issue_fix_version.version_id} ;;
#   }
#   join: issue {
#     type: left_outer
#     relationship: one_to_one
#     sql_on: ${issue_fix_version.issue_id} = ${issue.id} ;;
#   }
# }

# explore: issue_history_2 {
#   label: "Issue History"
# #  fields: [ALL_FIELDS*, -issue.total_open_story_points,-issue.total_closed_story_points]
#   view_name: issue
#
# # #  always_filter: {
# #     filters: {
# #       field: issue.id
# #       value: ""
# #     }
# #   }
#
#   join: issue_history_all {
#     type:  left_outer
#     sql_on: ${issue.id} = ${issue_history_all.issue_id} ;;
#     relationship: many_to_one
#   }
# }

### CURRENT OVERVIEW OF STATUS OF PROJECTS, ISSUES, AND ISSUE FACTS (E.G. # OF COMMENTS)

# explore: project {
#   join: issue {
#     type:  left_outer
#     sql_on: ${project.id} = ${issue.project} ;;
#     relationship: many_to_one
#   }
#   join:  issue_type {
#     type:  left_outer
#     sql_on: ${issue.issue_type} = ${issue_type.id} ;;
#     relationship: many_to_one
#   }
#   join: issue_sprint {
#     type: left_outer
#     sql_on: ${issue_sprint.issue_id} = ${issue.id} ;;
#     relationship: many_to_one
#   }
#   join: sprint {
#     from: sprint_details
#     type: left_outer
#     sql_on: ${issue_sprint.sprint_id} = ${sprint.id} ;;
#     relationship: many_to_one
#   }
#   join:  priority {
#     type:  left_outer
#     sql_on: ${issue.priority} = ${priority.id} ;;
#     relationship: many_to_one
#   }
#   join:  status {
#     type:  left_outer
#     sql_on: ${issue.status} = ${status.id} ;;
#     relationship: many_to_one
#   }
#   join:  status_category {
#     type:  left_outer
#     sql_on: ${status.status_category_id} = ${status_category.id} ;;
#     relationship: many_to_one
#   }
#
#   ### AS OF NOW, FACT TABLE ONLY INCLUDES COMMENT INFORMATION - SHOULD MAKE THIS A GIANT DERIVED TABLE
#   ### WITH FACTS FROM ALL ISSUE-RELATED TABLES SUCH AS PRIORITY, TYPE, ETC.
#
#   join:  issue_comment_facts {
#     type:  left_outer
#     sql_on: ${issue.id} = ${issue_comment_facts.issue_id} ;;
#     relationship: many_to_one
#   }
# }


### HISTORICAL OVERVIEWS

# explore: sprint_by_date {
#   label: "Sprint History"
#
#   join: issue {
#     view_label: "Issue"
#     type: left_outer
#     sql_on: ${sprint_by_date.issue_id} = ${issue.id} ;;
#     relationship: many_to_one
#   }
#
#   ### JOIN SINGULAR TABLES WITH NO ASSOCIATED HISTORY TABLES
#
#   join: issue_type {
#     type: left_outer
#     sql_on: ${issue.issue_type} = ${issue_type.id} ;;
#     relationship: many_to_one
#   }
#
#   join: priority {
#     view_label: "Issue Priority"
#     type: left_outer
#     sql_on: ${issue.priority} = ${priority.id} ;;
#     relationship: many_to_one
#   }
#
#   join: sprint {
#     type: left_outer
#     sql_on: ${sprint.id} = ${sprint_by_date.sprint_id} ;;
#     relationship: many_to_one
#   }
#
#   join: sprint_details {
#     type: left_outer
#     sql_on: ${sprint_details.id} = ${sprint_by_date.sprint_id} ;;
#     relationship: many_to_one
#   }
#
#   join: status {
#     view_label: "Issue Status"
#     type: left_outer
#     sql_on: ${status.id} = ${issue.status} ;;
#     relationship: many_to_one
#   }
#
#   join: status_category {
#     view_label: "Issue Status"
#     type: left_outer
#     sql_on: ${status.status_category_id} = ${status_category.id} ;;
#     relationship: many_to_one
#   }
# }


# explore: sprint_burndown {
#   view_name: looker_calendar
#   join: issue {
#     type: left_outer
#     sql_on:
#     ${looker_calendar.series_date_raw} >= ${issue.created_raw}
#     AND ${looker_calendar.series_date_raw} <= NVL(${issue.resolved_raw},current_date)
#     ;;
#     relationship: one_to_many
#   }
#   join: issue_sprint {
#     type: left_outer
#     sql_on: ${issue.id} = ${issue_sprint.issue_id} ;;
#     relationship: one_to_many
#   }
#   join: sprint {
#     type: left_outer
#     sql_on: ${issue_sprint.sprint_id} = ${sprint.id} ;;
#     relationship: many_to_one
#   }
#   join: sprint_start_points {
#     type: left_outer
#     sql_on: ${sprint.id} = ${sprint_start_points.id} ;;
#     relationship: one_to_one
#   }
#
#   join:  status {
#     type:  left_outer
#     sql_on: ${issue.status} = ${status.id} ;;
#     relationship: many_to_one
#   }
#
#   sql_always_where:
#    ${looker_calendar.series_date_raw} >= ${sprint.start_raw}
#   AND ${looker_calendar.series_date_raw} <= ${sprint.end_raw}
#   ;;
#   #always_filter: {
#   #  filters: {
#   #    field: sprint.name
#   #    value: "Data Sprint 5"
#   #  }
#   #}
#
# }
