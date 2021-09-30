view: derived_issue_status_history {
  derived_table: {
    sql:
      select
      issue_id,
      CAST(value AS INT64) as status_id,
      s.name as status_name,
      author_id,
      is_active,
      time,
      lag(value) over (PARTITION BY issue_id ORDER BY time asc) as preceding_value,
      lag(s.name) over (PARTITION BY issue_id ORDER BY time asc) as preceding_status_name,
      lag(time) OVER (PARTITION BY issue_id ORDER BY time asc) as preceding_time,
      FIRST_VALUE(time) OVER (PARTITION BY issue_id ORDER BY time ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS started,
      LAST_VALUE(time) OVER (PARTITION BY issue_ID ORDER BY time ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS most_recent
      from issue_field_history h join status s on CAST(h.value AS INT64) = s.id
      where lower(h.field_id) = 'status'
       ;;
  }

  dimension: author_id  {
    type: string
    label: "Author"
    sql: ${TABLE}.author_id ;;
  }

  dimension: is_active  {
    type: yesno
    label: "Is active"
    sql: ${TABLE}.is_active ;;
  }

  measure: count {
    type: count
    label: "Status change count"
    drill_fields: [detail*]
  }

  dimension: issue_id {
    type: number
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.issue_id ;;
  }

  dimension: status_id {
    type: number
    hidden: yes
    sql: ${TABLE}.status_id ;;
  }

  dimension: status_name {
    type: string
    label: "Status"
    sql: ${TABLE}.status_name ;;
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

  dimension: preceding_status_id {
    type: number
    hidden: yes
    sql: ${TABLE}.preceding_value ;;
  }

  dimension: preceding_status_name {
    type: string
    group_label: "Preceding"
    label: "Preceding status"
    sql: ${TABLE}.preceding_status_name ;;
  }

  dimension: status_trasnsition {
    type: string
    label: "Status transition"
    sql: case when (${preceding_status_name} is null) then ${status_name} else CONCAT(${preceding_status_name}," to ",${status_name}) end ;;
  }

  dimension_group: preceding_time {
    type: time
    group_label: "Preceding"
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

  dimension_group: duration_preceding {
    type: duration
    group_label: "Preceding"
    label: "Duration preceding"
    sql_start:${TABLE}.preceding_time  ;;
    sql_end:  ${TABLE}.time ;;
    intervals: [hour,day]
  }

  dimension_group: started {
    type: time
    group_label: "Started"
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
    group_label: "Started"
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
      status_id,
      time_time,
      preceding_status_id,
      preceding_time_time,
      started_time,
      most_recent_time
    ]
  }
}
