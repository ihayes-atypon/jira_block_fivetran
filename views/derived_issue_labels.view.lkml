view: derived_issue_labels {
  derived_table: {
    sql:

    with ex_issue_labels_history as (
      SELECT * FROM issue_multiselect_history
      WHERE field_id = 'labels'
    )

    select
      H.issue_id,
      H.value,
      issue.created as issue_created,
      H.time as label_created,
      H.author_id,
      H.is_active
      from ex_issue_labels_history H
      left join issue on H.issue_id = issue.id
      ;;
  }

  measure: count {
    type: count
    label: "Label count"
    drill_fields: [detail*]
  }

  dimension: author_id {
    type: string
    label: "Author"
    sql: ${TABLE}.author_id ;;
  }

  dimension: is_active {
    type: yesno
    label: "Is active"
    sql: ${TABLE}.is_active ;;
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
