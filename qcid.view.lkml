view: qcid {
  sql_table_name: logfiles.QCID ;;

  dimension: action {
    type: string
    sql: ${TABLE}.Action ;;
  }

  dimension: grouped_action {
    type: string
    sql:CASE
      WHEN ${action} like '%Marker' THEN 'Add Marker'
      WHEN ${action} like 'Annotation%' THEN 'Add Annotation'
      WHEN ${action} like 'Rotate Image%' THEN 'Rotate Image'
      ELSE ${action}
    END;;

    link: {
      label: "{{value}} Drill Down Dashboard"
      url: "/dashboards/3?Reason={{ value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }

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
      year,
      time_of_day
    ]
    sql: ${TABLE}.Timestamp ;;
  }

  dimension: weekday {
    type: number
    sql: ${TABLE}.Weekday ;;
  }

  # plain and stupid count - no business logic
  measure: count {
    type: count
    drill_fields: [solution, institution_name, exam_group_name_enclustered, exposure_type_name_en]
  }

  # count per unique session, e.g. only count 3 foot images as a single foot exam
  measure: count_unique_per_session {
    type: count_distinct
    sql:  ${session_uid} ;;
    drill_fields: [solution, institution_name, exam_group_name_enclustered, exposure_type_name_en]
  }

  # count per unique image, e.g. if user presses "rotate image" several times for a single image, only count 1
  measure: count_unique_per_image {
    type: count_distinct
    sql:  ${sopuid} ;;
    drill_fields: [solution, institution_name, exam_group_name_enclustered, exposure_type_name_en]
  }

}
