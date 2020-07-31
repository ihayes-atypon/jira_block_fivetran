view: derived_issue_labels {
  derived_table: {
    sql: select
      issue_labels._fivetran_id,
      issue_labels.issue_id,
      issue_labels.value,
      issue.created as issue_created,
      issue_labels_history.time as label_created
      from issue_labels
      left join issue on issue_labels.issue_id = issue.id
      left join issue_labels_history on issue_labels.issue_id = issue_labels_history.issue_id and issue_labels.value = issue_labels_history.value
       ;;
  }

  dimension: label_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}._fivetran_id ;;
  }

  measure: count {
    type: count
    label: "Label count"
    drill_fields: [detail*]
  }

  dimension: issue_id {
    type: number
    hidden: yes
    sql: ${TABLE}.issue_id ;;
  }

  dimension: value {
    type: string
    label: "Label"
    sql: ${TABLE}.value ;;
  }

  dimension_group: issue_created {
    type: time
    hidden: yes
    sql: ${TABLE}.issue_created ;;
  }

  dimension_group: label_created {
    type: time
    hidden: yes
    sql: ${TABLE}.label_created ;;
  }

  dimension_group: label_date {
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
    label: "Label created"
    sql: case when ${TABLE}.label_created is not null then  ${TABLE}.label_created else ${TABLE}.issue_created end ;;
  }

  set: detail {
    fields: [issue_id, value, issue_created_time, label_created_time]
  }
}
