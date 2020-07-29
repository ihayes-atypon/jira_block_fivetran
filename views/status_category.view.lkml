  view: status_category {
    sql_table_name: JIRA.STATUS_CATEGORY ;;

    dimension: id {
      primary_key: yes
      hidden: yes
      type: number
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

    dimension: name {
      type: string
      label: "Status category"
      sql: ${TABLE}.NAME ;;
    }

    measure: count {
      type: count
      hidden: yes
      drill_fields: [id, name, status.count]
    }
  }
