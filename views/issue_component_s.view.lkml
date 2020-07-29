view: issue_component_s {
  sql_table_name: issue_component_s
    ;;

  dimension: _fivetran_id {
    type: string
    hidden: yes
    sql: ${TABLE}._fivetran_id ;;
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

  dimension: component_id {
    type: number
    hidden: yes
    sql: ${TABLE}.component_id ;;
  }

  dimension: issue_id {
    type: number
    hidden: yes
    sql: ${TABLE}.issue_id ;;
  }

  measure: count {
    type: count
    hidden:yes
    drill_fields: []
  }
}
