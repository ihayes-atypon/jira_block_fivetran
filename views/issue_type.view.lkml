  view: issue_type {

    sql_table_name: issue_type ;;

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
      label: "Issue type description"
      sql: ${TABLE}.description ;;
    }

    dimension: name {
      type: string
      label: "Issue type"
      sql: ${TABLE}.name ;;
    }

    dimension: subtask {
      type: yesno
      label: "Is sub task"
      sql: ${TABLE}.subtask ;;
    }

    dimension: is_bug {
      type: yesno
      label: "Is bug"
      sql: LOWER(${name}) = 'bug' ;;
    }

    dimension: client_related {
      type: yesno
      label: "Client related ticket"
      sql: LOWER(trim(${TABLE}.name)) IN ('task','improvement','inquiry','bug','story','incident','milestone','task.','epic') ;;
    }

    dimension: type_category {
      label: "Issue type category"
     case: {
       when: {
         sql: LOWER(${name}) = 'bug' ;;
         label: "Bug"
       }
      when: {
        sql: LOWER(TRIM( ${name} )) IN ('story','improvement','change request','task','task.','milestone','epic') ;;
        label: "Improvement"
      }
      when: {
        sql: LOWER(trim(${name})) IN ('incident') ;;
        label: "Incident"
      }
      when: {
        sql: LOWER(trim(${name})) IN ('inquiry') ;;
        label: "Inquiry"
      }
      else: "Other"
     }
    }

    measure: count {
      type: count
      hidden: yes
      drill_fields: [id, name]
    }
  }
