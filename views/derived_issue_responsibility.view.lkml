view: derived_issue_responsibility {
  derived_table: {
    sql:

    with issue_field_responsibility as (
       select
         issue_id,
         value
      from issue_field_history f
      where
         f.field_id = 'customfield_14014'
      and
         f.is_active = true
    )

    select
      f.issue_id,
      p.name as responsibility
      from issue_field_responsibility f
      left join field_option p on CAST(f.value AS INT64) = p.id
      ;;
  }

  dimension: issue_id {
    type: number
    hidden: yes
    sql: ${TABLE}.issue_id ;;
  }

  dimension: responsibility {
    type: string
    label: "Responsibility"
    sql: ${TABLE}.responsibility ;;
  }

}
