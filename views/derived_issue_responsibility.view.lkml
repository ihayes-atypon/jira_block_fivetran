view: derived_issue_responsibility {
  derived_table: {
    sql:

   WITH
   latest_responsibility as (
      SELECT
         issue_id,
         field_id,
         max(time) as max_time
      FROM issue_field_history
      where
         field_id = 'customfield_14014'
      GROUP BY 1,2
    ),
    issue_field_responsibility as (
       select
         h.issue_id,
         h.value
      from issue_field_history h
      inner join latest_responsibility g on h.issue_id = g.issue_id AND h.field_id = g.field_id AND h.time = g.max_time
      where
         h.field_id = 'customfield_14014'
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
