view: issue_labels_history {
  sql_table_name: issue_labels_history
    ;;

  dimension: _fivetran_id {
    type: string
    sql: ${TABLE}._fivetran_id ;;
    hidden: yes
    primary_key: yes
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

  dimension: issue_id {
    type: number
    hidden: yes
    sql: ${TABLE}.issue_id ;;
  }

  dimension_group: time {
    type: time
    label: "Label created"
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

  dimension: value {
    type: string
    label: "Label"
    sql: ${TABLE}.value ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
