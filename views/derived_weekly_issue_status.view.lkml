view: derived_weekly_issue_status {
  derived_table: {
    sql:

    WITH
    reportWeek AS (
           SELECT
            TIMESTAMP_SUB(TIMESTAMP_ADD(TIMESTAMP(eowDate),INTERVAL 1 DAY),INTERVAL 1 SECOND) as endOfWeekDate
            FROM UNNEST(
            GENERATE_DATE_ARRAY(
                     DATE_SUB( LAST_DAY(CURRENT_DATE(),WEEK(MONDAY)),INTERVAL 104 WEEK),
                     LAST_DAY(CURRENT_DATE(),WEEK(MONDAY)),
                    INTERVAL 1 WEEK)
         ) AS eowDate
      ),
    flatten3 as (
       SELECT
          issue_id,
          time,
          field_id,
          value,
          case when lower(field_id) = 'assignee' then value else null end as assignee,
          case when lower(field_id) = 'status' then CAST(value as INT64) else null end as statusId,
       FROM
          issue_field_history
       WHERE
          lower(field_id) IN ('assignee','status')
    ),
    flatten4 as (
       SELECT
         issue_id,
         time,
         field_id,
         value,
         assignee,
         case when assignee is null then LAST_VALUE(assignee IGNORE NULLS) OVER (PARTITION BY issue_id ORDER BY time asc) else assignee end as assignee1,
         case when statusId is null then LAST_VALUE(statusId IGNORE NULLS) OVER (PARTITION BY issue_id ORDER BY time asc) else statusId end as statusId2
       FROM
          flatten3 f
       ORDER BY 1,2 asc
    ),
    ex_issue_state_history as (
      SELECT
        issue_id,
        time as changed,
        statusId2 as newStatusId,
        s.name as newStatusName,
        assignee1 as newAssignee
      FROM flatten4 f
      LEFT JOIN status s on f.statusId2 = s.id
    )

    SELECT
      i.id,
      i.key,
      i.created as started,
      i.resolved,
      m.endOfWeekDate,
      ARRAY_AGG(newAssignee ORDER BY changed DESC)[OFFSET(0)] as weekEndAssignee,
      ARRAY_AGG(newStatusName ORDER BY changed DESC)[OFFSET(0)] as weekEndStatusName,
      ARRAY_AGG(newStatusId ORDER BY changed DESC)[OFFSET(0)] as weekEndStatusId,
      ARRAY_AGG(changed ORDER BY changed DESC)[OFFSET(0)] as mostRecentChange,
    FROM issue i
    CROSS JOIN reportWeek m
    INNER JOIN ex_issue_state_history e ON i.id = e.issue_id AND e.changed <= m.endOfWeekDate
    GROUP BY 1, 2, 3, 4, 5
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

  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }

  dimension_group: started {
    label: "Created"
    type: time
    timeframes: [
      raw,
      date,
      week,
      week_of_year,
      year
    ]
    datatype: timestamp
    sql:${TABLE}.started ;;
  }

  dimension_group: created_to_now {
    type: duration
    label: "Created to now"
    intervals: [hour,day,week]
    sql_start:${TABLE}.started ;;
    sql_end:  now()  ;;
  }

  dimension_group: end_of_week {
    label: "Week end"
    type: time
    timeframes: [
      raw,
      date,
      time,
      week,
      week_of_year,
      year
    ]
    drill_fields: [key]
    datatype: timestamp
    sql: ${TABLE}.endOfWeekDate ;;
  }

  dimension_group: start_of_week_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      week_of_year,
      year
    ]
    label: "Week start"
    datatype: timestamp
    sql:  TIMESTAMP_SUB(TIMESTAMP(${end_of_week_date}),INTERVAL 6 DAY)  ;;
  }


  dimension_group: created_to_week_end {
    type: duration
    label: "Created to week end"
    intervals: [hour,day,week]
    sql_start:${TABLE}.started ;;
    sql_end:  ${TABLE}.endOfWeekDate  ;;
  }

  dimension: raw_week_end_status_name  {
    type: string
    label: "Raw week end status"
    sql:  ${TABLE}.weekEndStatusName;;
  }

  dimension:  week_end_assignee {
    type: string
    label: "Week end assignee"
    sql: ${TABLE}.weekEndAssignee  ;;
  }

  dimension: week_end_status_name {
    type: string
    label: "Week end status"
    sql: case
           when ${open_at_week_end} = false and ${TABLE}.weekEndStatusName not in ('Resolved', 'Closed') then 'Resolved'
           else ${TABLE}.weekEndStatusName
          end;;
  }

  dimension_group: resolved {
    type: time
    timeframes: [
      raw,
      date,
      week,
      week_of_year,
      year
    ]
    datatype: timestamp
    sql: ${TABLE}.resolved ;;
  }

  dimension_group: created_to_resolved {
    type: duration
    label: "Created to resolved"
    intervals: [hour,day,week]
    sql_start:${TABLE}.started ;;
    sql_end:  ${TABLE}.resolved  ;;
  }


  dimension: week_end_status_id {
    type: number
    hidden: yes
    sql: ${TABLE}.weekEndStatusId ;;
  }

  dimension_group: most_recent_change {
    label: "Most recent change"
    type: time
    timeframes: [
      raw,
      date,
      week,
      week_of_year,
      year
    ]
    sql: ${TABLE}.mostRecentChange ;;
  }

  dimension_group: created_to_most_recent_change {
    type: duration
    label: "Created to most recent change"
    intervals: [hour,day,week]
    sql_start:${TABLE}.started ;;
    sql_end:  ${TABLE}.mostRecentChange  ;;
  }

  dimension: created_in_week {
    type: yesno
    label: "Created in week"
    sql:   DATE(${TABLE}.started) >= DATE(${start_of_week_date_date}) AND DATE(${TABLE}.started) <= DATE(${TABLE}.endOfWeekDate) ;;
  }

  measure: count_created_in_week {
    type: count
    label: "Created in week"
    filters: [created_in_week: "yes"]
  }

  dimension: most_recent_transition_in_week {
    type: yesno
    label: "Most recent change in week"
    sql:   DATE(${TABLE}.mostRecentChange) >= DATE(${start_of_week_date_date}) AND DATE(${TABLE}.mostRecentChange) <= DATE(${TABLE}.endOfWeekDate) ;;
  }

  dimension: open_at_week_end {
    type: yesno
    label: "Open at week end"
    sql:  case
            when ((${resolved_date} is null) AND ${TABLE}.weekEndStatusName NOT IN ('Resolved','Closed')) OR (DATE(${resolved_date}) > DATE(${end_of_week_date})) then true
            else false
          end;;
  }

  dimension: resolved_in_week {
    type: yesno
    label: "Resolved in week"
    sql:   DATE(${TABLE}.resolved) >= DATE(${start_of_week_date_date}) AND DATE(${TABLE}.resolved) <= DATE( ${TABLE}.endOfWeekDate) ;;
  }

  dimension: resolved_at_week_end {
    type: yesno
    label: "Resolved at end of week"
    sql: ${resolved_date} <= ${end_of_week_date}  ;;
  }

  measure: count_resolved_in_week {
    type: count
    label: "Resolved in week"
    filters: [resolved_in_week: "yes"]
  }

  dimension: closed_in_week {
    type: yesno
    label: "Closed in week"
    sql:  ${week_end_status_name} = 'Closed' and ${most_recent_transition_in_week} = true;;
  }

  measure: count_closed_in_week {
    type: count
    label: "Closed in week"
    filters: [most_recent_transition_in_week: "yes",closed_in_week: "yes"]
  }

  measure: count_cumulative_open_at_week_end {
    type: count
    label: "Open cumulative"
    filters: [open_at_week_end: "yes"]
  }

  measure: average_days_open_at_week_end {
    type: average
    label: "Average days open at week end"
    description: "For issues open at the week end, this is average number of days that have elapsed since the issue was created"
    value_format_name: decimal_0
    sql: ${days_created_to_week_end};;
    filters: [open_at_week_end: "yes"]
  }

}
