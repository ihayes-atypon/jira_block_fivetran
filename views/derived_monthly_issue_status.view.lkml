view: derived_monthly_issue_status {
  derived_table: {
    sql: WITH reportMonth AS (
         SELECT TIMESTAMP_SUB(TIMESTAMP(endOfMonthDate),INTERVAL 1 SECOND) as endOfMonth FROM UNNEST(
                   GENERATE_DATE_ARRAY(
                           DATE_SUB(DATE_TRUNC(DATE_ADD(CURRENT_DATE(),INTERVAL 1 MONTH),MONTH),INTERVAL 253 MONTH),
                           DATE_TRUNC(DATE_ADD(CURRENT_DATE(),INTERVAL 1 MONTH),MONTH),
                          INTERVAL 1 MONTH)
        ) AS endOfMonthDate
      ),
      ex_issue_state_history as (
        select
        a.issue_id,
        a.time as changed,
        a.status_id as newStatusId,
        s.name as newStatusName,
        from issue_status_history a
        left join status s on a.status_id = s.id
      )

      SELECT
            i.id,
            i.created as started,
            i.resolved,
            m.EndOfMonth,
            ARRAY_AGG(newStatusName ORDER BY changed DESC)[OFFSET(0)] as monthEndStatusName,
            ARRAY_AGG(newStatusId ORDER BY changed DESC)[OFFSET(0)] as monthEndStatusId,
            ARRAY_AGG(changed ORDER BY changed DESC)[OFFSET(0)] as mostRecentChange,
            FROM issue i
            CROSS JOIN reportMonth m
            INNER JOIN ex_issue_state_history e ON i.id = e.issue_id AND e.changed <= m.endOfMonth
            GROUP BY 1, 2, 3, 4
            order by 1,2 asc
       ;;
  }

  measure: count {
    hidden: yes
    type: count
  }

  dimension: id {
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
    hidden: yes
  }

  dimension_group: started {
    label: "Created"
    type: time
    timeframes: [
      raw,
      date,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.started ;;
  }

  dimension_group: created_to_now {
    type: duration
    label: "Created to now"
    intervals: [hour,day,week,month]
    sql_start:${TABLE}.started ;;
    sql_end:  now()  ;;
  }

  dimension_group: end_of_month {
    label: "Month end"
    type: time
    timeframes: [
      raw,
      date,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.EndOfMonth ;;
  }

  dimension_group: created_to_month_end {
    type: duration
    label: "Created to month end"
    intervals: [hour,day,week,month]
    sql_start:${TABLE}.started ;;
    sql_end:  ${TABLE}.EndOfMonth  ;;
  }

   dimension: raw_month_end_status_name  {
    type: string
    label: "Raw month end status"
    sql:  ${TABLE}.monthEndStatusName;;
   }

  dimension: month_end_status_name {
    type: string
    label: "Month end status"
    sql: case
           when ${open_at_month_end} = false and ${TABLE}.monthEndStatusName not in ('Resolved', 'Closed') then 'Resolved'
           else ${TABLE}.monthEndStatusName
          end;;
  }

  dimension_group: resolved {
    type: time
    timeframes: [
      raw,
      date,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.resolved ;;
  }

  dimension_group: created_to_resolved {
    type: duration
    label: "Created to resolved"
    intervals: [hour,day,week,month]
    sql_start:${TABLE}.started ;;
    sql_end:  ${TABLE}.resolved  ;;
  }


  dimension: month_end_status_id {
    type: number
    hidden: yes
    sql: ${TABLE}.monthEndStatusId ;;
  }

  dimension_group: most_recent_change {
    label: "Most recent change"
    type: time
    timeframes: [
      raw,
      date,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.mostRecentChange ;;
  }

  dimension_group: created_to_most_recent_change {
    type: duration
    label: "Created to most recent change"
    intervals: [hour,day,week,month]
    sql_start:${TABLE}.started ;;
    sql_end:  ${TABLE}.mostRecentChange  ;;
  }

  dimension: created_in_month {
    type: yesno
    label: "Created in month"
    sql:   ${TABLE}.started >= TIMESTAMP_TRUNC(${TABLE}.EndOfMonth,MONTH) AND ${TABLE}.started <= ${TABLE}.EndOfMonth ;;
  }

  measure: count_created_in_month {
    type: count
    label: "Created in month"
    filters: [created_in_month: "yes"]
  }

  dimension: most_recent_transition_in_month {
    type: yesno
    label: "Most recent change in month"
    sql:   ${TABLE}.mostRecentChange >= TIMESTAMP_TRUNC(${TABLE}.EndOfMonth,MONTH) AND ${TABLE}.mostRecentChange <= ${TABLE}.EndOfMonth ;;
  }

  dimension: open_at_month_end {
    type: yesno
    label: "Open at month end"
    sql:  case
            when ((${resolved_date} is null) AND ${TABLE}.monthEndStatusName NOT IN ('Resolved','Closed')) OR (${resolved_date} > ${end_of_month_date}) then true
            else false
          end;;
  }

  dimension: resolved_in_month {
    type: yesno
    label: "Resolved in month"
    sql:   ${TABLE}.resolved >= TIMESTAMP_TRUNC(${TABLE}.EndOfMonth,MONTH) AND ${TABLE}.resolved <= ${TABLE}.EndOfMonth ;;
    }

  dimension: resolved_at_month_end {
    type: yesno
    label: "Resolved at end of month"
    sql: ${resolved_date} <= ${end_of_month_date}  ;;
  }

  measure: count_resolved_in_month {
    type: count
    label: "Resolved in month"
    filters: [resolved_in_month: "yes"]
  }

  dimension: closed_in_month {
    type: yesno
    label: "Closed in month"
    sql:  ${month_end_status_name} = 'Closed' and ${most_recent_transition_in_month} = true;;
  }

  measure: count_closed_in_month {
    type: count
    label: "Closed in month"
    filters: [most_recent_transition_in_month: "yes",closed_in_month: "yes"]
  }

  measure: count_cumulative_open_at_month_end {
    type: count
    label: "Open cumulative"
    filters: [open_at_month_end: "yes"]
  }

}
