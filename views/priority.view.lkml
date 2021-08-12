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

    dimension:  value{
      type: number
      label: "Priority value"
      sql:
         case
           when LOWER(${name}) = 'p1 (blocker)' then 25
           when LOWER(${name}) = 'p2 (critical)' then 15
           when LOWER(${name}) = 'p3 (normal)' then 2
           when LOWER(${name}) = 'p4 (minor)' then 1
           when LOWER(${name}) = 'sla1' then 25
           when LOWER(${name}) = 'sla2' then 15
           else 0
         end ;;

    }

    measure: count {
      hidden : yes
      type: count
      drill_fields: [id, name, issue_priority_history.count]
    }
  }
