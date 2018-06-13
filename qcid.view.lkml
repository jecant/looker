view: qcid {
  sql_table_name: logfiles.QCID ;;

  parameter: action_filter {
    type: string
    suggest_dimension: action
    description: "Use when looking at count of actions per image acquired"
  }

  dimension: action {
    type: string
    sql: ${TABLE}.Action ;;
  }

  dimension: cleaned_reject_reason {
    type: string
    sql: CASE
      WHEN ${action} like 'Reject Reason%' THEN REPLACE(REPLACE(${action},'Reject Reason [',''),']','')
      ELSE ${action}
    END;;
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

  set: drilldown {
    fields: [solution, institution_name, exam_group_name_enclustered, exposure_type_name_en]
  }

  # plain and stupid count - no business logic
  measure: count {
    type: count
    drill_fields: [drilldown*]
  }

  # count per unique session, e.g. only count 3 foot images as a single foot exam
  measure: count_unique_per_session {
    type: count_distinct
    sql:  ${session_uid} ;;
    drill_fields: [drilldown*]
  }

  # count per unique image, e.g. if user presses "rotate image" several times for a single image, only count 1
  measure: count_unique_per_image {
    type: count_distinct
    sql:  ${sopuid} ;;
    drill_fields: [drilldown*]
  }

  measure: count_unique_action {
    type: count_distinct
    sql:  CASE WHEN LOWER(${action}) like LOWER({% parameter action_filter %}) THEN ${sopuid} ELSE NULL END ;;
    description: "Use with action filter parameter"
    drill_fields: [drilldown*]
  }

  measure: count_unique_image_acquired {
    type: count_distinct
    sql:  ${sopuid} ;;
    filters: {
      field: action
      value: "ImageAcquired"
    }
    drill_fields: [drilldown*]
  }

  measure: count_unique_per_image_acquired {
    type: number
    sql: ${count_unique_action}/NULLIF(${count_unique_image_acquired},0) ;;
    value_format_name: percent_0
    description: "Use with action filter parameter"
    drill_fields: [drilldown*]
  }

}
