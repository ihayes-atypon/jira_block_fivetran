view: derived_issue_affected_version {
  derived_table: {
    sql:

    WITH issue_affected_version as (
       SELECT
          issue_id,
          value
       FROM issue_multiselect_history m
       WHERE m.field_id = 'versions'
       AND m.is_active = true
       AND m.value is not null
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
