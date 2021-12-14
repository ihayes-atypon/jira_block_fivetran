  view: version {
    sql_table_name:version ;;

    dimension: id {
      primary_key: yes
      type: number
      sql: ${TABLE}.ID ;;
      hidden: yes
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
      sql: ${TABLE}._FIVETRAN_SYNCED ;;
      hidden:  yes
    }

    dimension: archived {
      type: yesno
      sql: ${TABLE}.ARCHIVED ;;
      hidden:  yes
      }

    dimension: description {
      type: string
      sql: ${TABLE}.DESCRIPTION ;;
    }

    dimension: name {
      label: "Version"
      group_label: "Affected version"
      type: string
      sql: ${TABLE}.NAME ;;
    }

    dimension: overdue {
      label: "Overdue"
      group_label: "Affected version"
      type: yesno
      sql: ${TABLE}.OVERDUE ;;
    }

    dimension: project_id {
      type: number
      hidden: yes
      sql: ${TABLE}.PROJECT_ID ;;
    }

    dimension_group: release {
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      label: "Release"
      group_label: "Affected version"
      convert_tz: no
      datatype: date
      sql: ${TABLE}.RELEASE_DATE ;;
    }

    dimension: released {
      type: yesno
      label: "Released"
      group_label: "Affected version"
      sql: ${TABLE}.RELEASED ;;
    }

    dimension_group: start {
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      label: "Start"
      group_label: "Affected version"
      datatype: date
      sql: ${TABLE}.START_DATE ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
      hidden: yes
    }

    # ----- Sets of fields for drilling ------
    set: detail {
      fields: [
        id,
        name,
        project.id,
        project.name
      ]
    }
  }
