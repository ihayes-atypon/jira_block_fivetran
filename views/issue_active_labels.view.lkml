view: issue_active_labels {

    derived_table: {
      sql:

          with ex_issue_labels_history as (
            SELECT * FROM issue_multiselect_history
            WHERE field_id = 'labels'
          )

        select
        H.issue_id,
        STRING_AGG(H.value) as value,
        from ex_issue_labels_history H
        left join issue on H.issue_id = issue.id
        WHERE H.is_active is true
        GROUP BY H.issue_id
        ;;
    }
    dimension: labels {
      type:  string
      label: "Active labels"
      view_label: "Issue"
      sql:  ${TABLE}.value ;;
    }
    dimension: issue_id {
      type:  string
      label: "issue_id"
      view_label: "Issue"
      hidden: yes
      sql: ${TABLE}.issue_id ;;
    }
  }
