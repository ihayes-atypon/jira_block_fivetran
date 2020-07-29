view: worklog {
  sql_table_name:worklog
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    hidden: yes
  }

  dimension_group: _fivetran_synced {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}._fivetran_synced ;;
  }

  dimension: started_author_id {
    type: string
    label: "Author code"
    hidden: yes
    sql: ${TABLE}.author_id ;;
  }

  dimension: comment {
    type: string
    sql: ${TABLE}.comment ;;
  }

  dimension: issue_id {
    type: number
    hidden: yes
    sql: ${TABLE}.issue_id ;;
  }

  dimension_group: started {
    type: time
    hidden: yes
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

  dimension: time_spent_hours {
    type: number
    sql: ${TABLE}.time_spent_seconds / 3600;;
  }

  measure: sum_time_spent_hours {
    type: sum
    value_format_name: decimal_0
    label: "Time spent (hours)"
    sql: ${TABLE}.time_spent_seconds / 3600;;
  }

  measure: sum_time_spent_days {
    type: sum
    value_format_name: decimal_0
    label: "Time spent (8h days)"
    sql: ${TABLE}.time_spent_seconds / (3600*8);;
  }

  dimension: update_author_id {
    type: string
    hidden: yes
    sql: ${TABLE}.update_author_id ;;
  }

  dimension: author_id {
    type: string
    label: "Work author"
    sql: case when  ${TABLE}.update_author_id is not null then  ${TABLE}.update_author_id else ${TABLE}.author_id end   ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
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

  dimension_group: time_spent_date {
    type: time
    label: "Work completed"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: case when ${TABLE}.updated is not null then ${TABLE}.updated else${TABLE}.started end ;;
    }

  measure: count {
    type: count
    label: "Work log count"
    drill_fields: [id]
  }
}
