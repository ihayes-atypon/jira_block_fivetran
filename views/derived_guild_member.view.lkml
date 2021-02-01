# If necessary, uncomment the line below to include explore_source.

# include: "Jira_(Github).model.lkml"

view: derived_guild_member {
  derived_table: {
    explore_source: issue {
      column: assignee {}
      column: description {}
      column: epic_link {}
      column: key {}
      filters: {
        field: issue.key
        value: "REA%"
      }
    }
  }
  dimension: assignee {
    type: string
    label: "Member name"

  }
  dimension: description {

  }
  dimension: epic_link {
    type: number
  }
  dimension: key {
    label: "Member Jira key"
  }
}
