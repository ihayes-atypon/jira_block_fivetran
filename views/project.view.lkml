  view: project {
    sql_table_name: project ;;

    dimension: id {
      primary_key: yes
      type: number
      hidden: yes
      sql: ${TABLE}.ID ;;
    }

    dimension_group: _FIVETRAN_SYNCED {
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
      sql: ${TABLE}._fivetran_synced ;;
    }

    dimension: description {
      type: string
      label: "Project description"
      sql: ${TABLE}.DESCRIPTION ;;
    }

    dimension: key {
      type: string
      label: "Project key"
      sql: ${TABLE}.key ;;
    }

    dimension: name {
      type: string
      label: "Project name"
      sql: ${TABLE}.NAME ;;
    }

    dimension: project_category_id {
      type: number
      hidden: yes
      sql: ${TABLE}.PROJECT_CATEGORY_ID ;;
    }

    dimension: project_type_key {
      label: "Project type"
      type: string
      sql: ${TABLE}.project_type_key ;;
    }

    measure: count {
      type: count
      label: "Project count"
      drill_fields: [id, name, component.count, issue_project_history.count, version.count]
    }
  }
