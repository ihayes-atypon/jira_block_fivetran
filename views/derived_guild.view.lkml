view: derived_guild {
  derived_table: {
    explore_source: issue {
      column: id { field: epic.id }
      column: key { field: epic.key }
      column: name { field: epic.name }
      column: summary { field: epic.summary }
      filters: {
        field: epic.key
        value: "REA%"
      }
    }
  }
  dimension: id {
    label: "Guild EPIC ID"
    hidden: yes
    type: number
  }
  dimension: key {
    label: "Guild EPIC Key"
  }
  dimension: name {
    label: "Guild Name"
  }
  dimension: summary {
    label: "Guild Summary"
  }
}
