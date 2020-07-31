view: issue_labels {
  sql_table_name: issue_labels;;

  dimension: _fivetran_synced {
    type: string
    hidden: yes
    sql: ${TABLE}._FIVETRAN_SYNCED ;;
  }

  dimension: issue_id {
    type: number
    hidden: yes
    sql: ${TABLE}.ISSUE_ID ;;
  }

  dimension: value {
    type: string
    label: "Label"
    sql: ${TABLE}.VALUE ;;
  }

  measure: count {
    type: count
    label: "Label count"
    drill_fields: [issue.id, issue.epic_name]
  }
}
