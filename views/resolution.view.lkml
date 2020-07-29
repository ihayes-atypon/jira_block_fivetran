  view: resolution {
    sql_table_name: resolution ;;

    dimension: id {
      primary_key: yes
      hidden: yes
      type: number
      sql: ${TABLE}.ID ;;
    }

    dimension_group: _fivetran_synced {
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
      hidden: yes
      sql: ${TABLE}._FIVETRAN_SYNCED ;;
    }

    dimension: description {
      type: string
      hidden: yes
      sql: ${TABLE}.DESCRIPTION ;;
    }

    dimension: name {
      label: "Resolution"
      type: string
      sql: ${TABLE}.NAME ;;
    }

    measure: count {
      type: count
      hidden: yes
      drill_fields: [id, name]
    }
  }
