view: derived_issue_assignee_history {
  derived_table: {
    sql:
      select
      issue_id,
      author_id as changed_by,
      is_active,
      time,
      value as new_assignee,
      lag(value) over (PARTITION BY issue_id ORDER BY time asc) as preceding_assignee,
      lag(time) OVER (PARTITION BY issue_id ORDER BY time asc) as preceding_time,
      FIRST_VALUE(time) OVER (PARTITION BY issue_id ORDER BY time ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS started,
      LAST_VALUE(time) OVER (PARTITION BY issue_ID ORDER BY time ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS most_recent
      from issue_field_history h
      where lower(h.field_id) = 'assignee'
       ;;
  }

  dimension: changed_by  {
    type: string
    label: "Changed by"
    sql: ${TABLE}.changed_by ;;
  }

  dimension: new_assignee  {
    type: string
    label: "New assignee"
    sql: ${TABLE}.new_assignee ;;
  }

  dimension: is_active  {
    type: yesno
    label: "Is active"
    sql: ${TABLE}.is_active ;;
  }

  measure: count {
    type: count
    label: "History count"
    drill_fields: [detail*]
  }

  dimension: issue_id {
    type: number
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.issue_id ;;
  }

  dimension_group: time {
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
    sql: ${TABLE}.time ;;
  }



  dimension: is_first {
    type: yesno
    label: "Is first"
    sql: ${TABLE}.time = ${TABLE}.started;;
  }

  dimension: preceding_assignee {
    type: string
    label: "Preceding assignee"
    sql: ${TABLE}.preceding_assignee ;;
  }

  dimension_group: preceding_time {
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
    sql: ${TABLE}.preceding_time ;;
  }

  dimension_group: duration_preceding_time {
    type: duration
    label: "Preceding to time"
    sql_start:${TABLE}.preceding_time  ;;
    sql_end:  ${TABLE}.time ;;
    intervals: [hour,day]
  }

  dimension_group: duration_preceding_now {
    type: duration
    label: "Preceding to now"
    sql_start:${TABLE}.preceding_time  ;;
    sql_end:  CURRENT_TIMESTAMP() ;;
    intervals: [hour,day]
  }

  dimension: duration_preceding_now {
    type: number
    label: "Days with preceeding assignee (not closed only)"
    sql: case when ${is_most_recent} then ${days_duration_preceding_now} else ${days_duration_preceding_time} end  ;;
  }

  dimension_group: started {
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
    sql: ${TABLE}.started ;;
  }

  dimension_group: duration_start {
    type: duration
    label: "Duration start"
    sql_start:${TABLE}.started  ;;
    sql_end:  ${TABLE}.time ;;
    intervals: [hour,day]
  }

  dimension_group: most_recent {
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
    sql: ${TABLE}.most_recent ;;
  }

  dimension: is_most_recent {
    type: yesno
    label: "Is most recent"
    sql: ${TABLE}.most_recent =  ${TABLE}.time;;
  }

  set: detail {
    fields: [
      issue_id,
      time_time,
      preceding_time_time,
      started_time,
      most_recent_time
    ]
  }
}
