view: derived_issue_affected_version {
  derived_table: {
    sql:

    WITH
    issue_affected_latest as (
       SELECT
         issue_id,
         field_id,
         MAX(time) as max_time
        FROM issue_multiselect_history
        WHERE field_id = 'versions'
        GROUP BY 1,2
    ),
    issue_affected_version as (
       SELECT
          m.issue_id,
          m.value
       FROM issue_multiselect_history m
       INNER JOIN issue_affected_latest g ON m.issue_id = g.issue_id AND m.field_id = g.field_id AND m.time = g.max_time
       WHERE m.field_id = 'versions'
    )

    SELECT
      m.issue_id,
      v.name as version
    FROM issue_affected_version m
    left join version v on CAST(m.value AS INT64) = v.id
      ;;
  }

  dimension: issue_id {
    type: number
    hidden: yes
    sql: ${TABLE}.issue_id ;;
  }

  dimension: responsibility {
    type: string
    label: "Affected version"
    sql: ${TABLE}.version ;;
  }

}
