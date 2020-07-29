  view: priority {
    sql_table_name: priority ;;

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
      hidden: yes
      sql: ${TABLE}.DESCRIPTION ;;
    }

    dimension: name {
      label: "Priority"
      type: string
      sql: ${TABLE}.NAME ;;
    }

    measure: count {
      hidden : yes
      type: count
      drill_fields: [id, name, issue_priority_history.count]
    }
  }
