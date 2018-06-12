view: demo_qcid {
  sql_table_name: logfiles.demo_qcid ;;

  dimension: action {
    type: string
    sql: ${TABLE}.Action ;;
  }

  dimension: exam_group_name {
    type: string
    sql: ${TABLE}.ExamGroupName ;;
  }

  dimension: exposure_type_name {
    type: string
    sql: ${TABLE}.ExposureTypeName ;;
  }

  dimension: session_uid {
    type: string
    sql: ${TABLE}.SessionUID ;;
  }

  dimension: sopuid {
    type: string
    sql: ${TABLE}.SOPUID ;;
  }

  dimension: system {
    type: string
    sql: ${TABLE}.System ;;
  }

  dimension_group: timestamp {
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
    sql: ${TABLE}.Timestamp ;;
  }
}
