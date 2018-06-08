view: qcid {
  sql_table_name: logfiles.QCID ;;

  dimension: action {
    type: string
    sql: ${TABLE}.Action ;;
  }

  dimension: exam_group_name {
    type: string
    sql: ${TABLE}.ExamGroupName ;;
  }

  dimension: exam_group_name_en {
    type: string
    sql: ${TABLE}.ExamGroupNameEN ;;
  }

  dimension: exam_group_name_enclustered {
    type: string
    sql: ${TABLE}.ExamGroupNameENClustered ;;
  }

  dimension: exposure_type_name {
    type: string
    sql: ${TABLE}.ExposureTypeName ;;
  }

  dimension: exposure_type_name_en {
    type: string
    sql: ${TABLE}.ExposureTypeNameEN ;;
  }

  dimension: field_case {
    type: string
    sql: ${TABLE}.FieldCase ;;
  }

  dimension: institution_name {
    type: string
    sql: ${TABLE}.InstitutionName ;;
  }

  dimension: session_uid {
    type: string
    sql: ${TABLE}.SessionUID ;;
  }

  dimension: solution {
    type: string
    sql: ${TABLE}.Solution ;;
  }

  dimension: sopuid {
    type: string
    sql: ${TABLE}.SOPUID ;;
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

  dimension: weekday {
    type: number
    sql: ${TABLE}.Weekday ;;
  }

  measure: count {
    type: count
    approximate_threshold: 100000
    drill_fields: [institution_name, exam_group_name, exposure_type_name]
  }
}
