view: qcid_utilization {
  derived_table: {
    sql: SELECT * FROM ${qcid_utilization_base.SQL_TABLE_NAME};;
    datagroup_trigger: default_datagroup
  }

  dimension: time_of_day {
    type: string
    sql: ${TABLE}.time_of_day_string ;;
  }

  dimension: hour_of_day {
    type: string
    sql: SUBSTR(${time_of_day},0,2) ;;
  }

  dimension: exam_group_name {
    type: string
    sql: ${TABLE}.ExamGroupName ;;
  }

  dimension: exposure_type_name {
    type: string
    sql: ${TABLE}.ExposureTypeName ;;
  }

  dimension: institution_name {
    type: string
    sql: ${TABLE}.InstitutionName ;;
  }

  dimension: solution {
    type: string
    sql: ${TABLE}.Solution ;;
  }

  dimension: exam_group_name_en {
    type: string
    sql: ${TABLE}.ExamGroupNameEN ;;
  }

  dimension: exposure_type_name_en {
    type: string
    sql: ${TABLE}.ExposureTypeNameEN ;;
  }

  dimension: exam_group_name_enclustered {
    type: string
    sql: ${TABLE}.ExamGroupNameENClustered ;;
  }

  dimension: number_of_utilised_days {
    type: number
    sql: ${TABLE}.number_of_utilised_days ;;
  }

  dimension: number_of_days {
    type: number
    sql: ${TABLE}.number_of_days ;;
  }

  set: detail {
    fields: [
      time_of_day,
      exam_group_name,
      exposure_type_name,
      institution_name,
      solution,
      exam_group_name_en,
      exposure_type_name_en,
      exam_group_name_enclustered,
      total_utilised_days,
      utilization
    ]
  }

  ###### Measures

  measure: total_utilised_days {
    type: sum
    sql: ${number_of_utilised_days} ;;
    drill_fields: [detail*]
  }

  measure: total_days {
    type: sum
    sql: ${number_of_days} ;;
    drill_fields: [detail*]
  }

  measure: utilization {
    type: number
    sql: ${total_utilised_days}/NULLIF(${total_days},0) ;;
    drill_fields: [detail*]
  }
}
