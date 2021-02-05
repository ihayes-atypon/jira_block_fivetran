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
    sql_on: ${component.project_id} = ${component_project.id} ;;
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
  # join: issue_labels {
  #   view_label: "Label"
  #   relationship: one_to_many
  #   sql_on: ${issue.id} = ${issue_labels.issue_id} ;;
  # }
  # join: issue_labels_history {
  #   view_label: "Label history"
  #   relationship: one_to_many
  #   sql_on: ${issue.id} = ${issue_labels_history.issue_id} ;;
  # }
  join: derived_issue_labels {
    view_label: "Label"
    relationship: one_to_many
    sql_on: ${issue.id} = ${derived_issue_labels.issue_id} ;;
  }
  join: epic {
    view_label: "EPIC"
    relationship: many_to_one
    sql_on: ${issue.epic_link} = ${epic.id} ;;
  }
  join: derived_guild_member {
    relationship: many_to_one
    sql_on: ${worklog.author_id} = ${derived_guild_member.assignee} ;;
  }
  join: derived_guild {
    view_label: "Guild"
    relationship: many_to_one
    sql_on: ${derived_guild_member.epic_link} = ${derived_guild.id} ;;
  }

}
