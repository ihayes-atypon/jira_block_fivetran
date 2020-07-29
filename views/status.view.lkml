  view: status {
    sql_table_name: JIRA.STATUS ;;

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
      label: "Status description"
      sql: ${TABLE}.DESCRIPTION ;;
    }

    dimension: name {
      type: string
      label: "Status"
      sql: ${TABLE}.NAME ;;
    }

    dimension: status_category_id {
      type: number
      hidden: yes
      sql: ${TABLE}.STATUS_CATEGORY_ID ;;
    }

    measure: count {
      hidden: yes
      type: count
      drill_fields: [id, name, status_category.id, status_category.name, issue_status_history.count]
    }
  }
