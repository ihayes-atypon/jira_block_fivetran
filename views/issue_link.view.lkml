view: issue_link {
  derived_table: {
    sql: select * from jira.v_issue_link ;;
  }


  dimension: issue_id {
    primary_key: yes
    type: number
     hidden: yes
    sql: ${TABLE}.ISSUE_ID ;;
  }

  measure: count {
    type: count
    label: "Linked Issues count"
  }

  dimension_group: created_to_first_internal_issue {
    type: duration
    label: "Duration (Created to Internal Issue created/linked)"
    sql_start:${TABLE}.issue2_created  ;;
    sql_end:  ${TABLE}.created ;;
    intervals: [hour,day]
  }

  dimension: relationship {
    type: string
    sql: ${TABLE}.RELATIONSHIP ;;
  }

  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
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


}
