      view: user {
        sql_table_name: user ;;

        dimension: id {
          primary_key: yes
          type: string
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
          sql: ${TABLE}._FIVETRAN_SYNCED ;;
        }

        dimension: email {
          type: string
          sql: ${TABLE}.EMAIL ;;
        }

        dimension: locale {
          type: string
          sql: ${TABLE}.LOCALE ;;
        }

        dimension: name {
          type: string
          sql: ${TABLE}.NAME ;;
        }

        dimension: time_zone {
          type: string
          sql: ${TABLE}.TIME_ZONE ;;
        }

        dimension: username {
          type: string
          sql: ${TABLE}.USERNAME ;;
        }


        measure: count {
          type: count
          label: "User count"
          drill_fields: [detail*]
        }

        dimension: atypon_user {
          type: yesno
          label: "Atypon user"
          sql: strpos(lower(${TABLE}.EMAIL),'atypon.com') > 0 ;;
          }

        # ----- Sets of fields for drilling ------
        set: detail {
          fields: [
            id,
            name,
            issue_assignee_history.count,
            issue_custom_multi_user.count,
            issue_custom_multi_user_history.count,
            issue_custom_single_user_history.count,
            issue_reporter_history.count,
            user_group.count
          ]
        }
      }
