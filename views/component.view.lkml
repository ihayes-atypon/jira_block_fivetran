  view: component {
    derived_table: {
      sql:

      WITH latest_component as (
         SELECT
            issue_id,
            field_id,
            max(time) as max_time
         FROM issue_multiselect_history
         WHERE
            field_id = 'components'
         GROUP BY 1,2
       )

     SELECT
        m._fivetran_id as id,
        m.issue_id,
        c.name,
        c.description,
        c.project_id
      FROM issue_multiselect_history m
      INNER JOIN latest_component g on m.issue_id = g.issue_id AND m.field_id = g.field_id AND m.time = g.max_time
      LEFT JOIN component c on CAST(m.value AS INT64) = c.id
      WHERE m.field_id = 'components'

      ;;
    }
    dimension: id {
      primary_key: yes
      type: string
      hidden: yes
      sql: ${TABLE}.id ;;
    }

    dimension:  issue_id {
      type: number
      label: "issue_id"
      hidden: yes
      sql: ${TABLE}.issue_id ;;
      }

    dimension: description {
      type: string
      sql: ${TABLE}.DESCRIPTION ;;
    }

    dimension: name {
      type: string
      sql: ${TABLE}.NAME ;;
    }

    dimension:project_id {
      type: number
      sql: ${TABLE}.project_id    ;;
    }

    measure: count {
      type: count
      hidden: yes
      drill_fields: [id, name, project.id, project.name]
    }
  }
