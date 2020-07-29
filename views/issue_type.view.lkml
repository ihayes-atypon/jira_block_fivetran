  view: issue_type {

    sql_table_name: issue_type ;;

    dimension: id {
      primary_key: yes
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

    dimension: description {
      type: string
      sql: ${TABLE}.description ;;
    }

    dimension: name {
      type: string
      label: "Issue type"
      sql: ${TABLE}.name ;;
    }

    dimension: subtask {
      type: yesno
      sql: ${TABLE}.subtask ;;
    }

    dimension: is_bug {
      type: yesno
      sql: ${name} = 'Bug' ;;
    }

    dimension: type_category {
      label: "Issue type category"
     case: {
       when: {
         sql: ${name} = 'Bug' ;;
         label: "Bug"
       }
      when: {
        sql: trim(${name}) IN ('Story','Improvement') ;;
        label: "Improvement"
      }
      when: {
        sql: trim(${name}) IN ('Story','Incident') ;;
        label: "Incident"
      }
      when: {
        sql: trim(${name}) IN ('Inquiry') ;;
        label: "Inquiry"
      }
      else: "Other"
     }
    }

    measure: count {
      type: count
      drill_fields: [id, name]
    }
  }
