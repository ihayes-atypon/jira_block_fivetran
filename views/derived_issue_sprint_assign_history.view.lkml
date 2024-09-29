view: derived_issue_sprint_assign_history {
  derived_table: {
    sql:
     select
issue.key as issue_key,
issue.id as issue_id,
sprint.name as sprint_name,
issue.created as issue_created,
imsh.time as sprint_assigned,
 FIRST_VALUE(imsh.time) OVER (PARTITION BY issue_id ORDER BY time ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_sprint_assigned,
 from
 issue issue
LEFT JOIN
 issue_multiselect_history imsh
on issue.id = imsh.issue_id and field_id = 'customfield_12400' and value is not null

left join sprint sprint
ON CAST(sprint.id as STRING) = imsh.value  ;;
  }

  dimension: issue_id {
    type: number
    hidden: yes
    sql: ${TABLE}.issue_id ;;
  }

  dimension: sprint_name {
    type: string
    label: "Sprint"
    sql: ${TABLE}.sprint_name ;;
  }

  dimension: sprint_assigned {
    type: date_time
    label: "Sprint Assign Timestamp"
    sql: ${TABLE}.sprint_assigned ;;
  }
  dimension_group: created_to_first_assignment {
    type: duration
    label: "Duration (Created to Assign Sprint)"
    sql_start:${TABLE}.issue_created  ;;
    sql_end:  ${TABLE}.first_sprint_assigned ;;
    intervals: [hour,day]
  }
}
