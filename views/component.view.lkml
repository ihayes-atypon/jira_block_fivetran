  view: component {
    sql_table_name: component ;;

    dimension: id {
      primary_key: yes
      type: number
      hidden: yes
      sql: ${TABLE}.ID ;;
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
      sql: ${TABLE}._FIVETRAN_SYNCED ;;
    }

    dimension: description {
      type: string
      sql: ${TABLE}.DESCRIPTION ;;
    }

    dimension: name {
      type: string
      sql: ${TABLE}.NAME ;;
    }

    dimension: project_id {
      type: number
      hidden: yes
      sql: ${TABLE}.PROJECT_ID ;;
    }

    measure: count {
      type: count
      hidden: yes
      drill_fields: [id, name, project.id, project.name]
    }
  }
