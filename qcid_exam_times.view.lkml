view: qcid_exam_times {
  derived_table: {
    sql:
       SELECT SessionUID
        ,STRING_AGG(distinct ExamGroupNameENClustered ORDER BY ExamGroupNameENClustered) AS ExamGroupNameENClusteredList
        ,MIN(timestamp) AS session_start
        ,MIN(CASE WHEN Action='Close And Send All' THEN timestamp ELSE NULL END) AS session_end
        ,TIMESTAMP_DIFF(MIN(CASE WHEN Action='Close And Send All' THEN timestamp ELSE NULL END)
          ,MIN(timestamp)
          ,SECOND) as session_length_seconds
      FROM ${qcid.SQL_TABLE_NAME}
      GROUP BY SessionUID;;
      datagroup_trigger: default_datagroup
  }

  dimension: session_uid {
    type: string
    sql: ${TABLE}.SessionUID ;;
    primary_key: yes
  }

  dimension: exam_group_name_enclustered_list {
    type: string
    sql: ${TABLE}.ExamGroupNameENClusteredList ;;
  }

  dimension_group: session_start {
    type: time
    sql: ${TABLE}.session_start ;;
  }

  dimension_group: session_end {
    type: time
    sql: ${TABLE}.session_end ;;
  }

  dimension: session_length {
    type: number
    description: "in seconds"
    sql: ${TABLE}.session_length_seconds/60.0 ;;
  }

  set: detail {
    fields: [session_uid, exam_group_name_enclustered_list, session_start_time, session_end_time, session_length]
  }

  measure: average_session_length {
    type: average
    sql: ${session_length} ;;
    drill_fields: [detail*]
  }

  measure: min_session_length {
    group_label: "Percentiles"
    type: min
    sql: ${session_length} ;;
    drill_fields: [detail*]
  }

  measure: session_length_quartile_1 {
    group_label: "Percentiles"
    type: percentile
    percentile: 25
    sql: ${session_length} ;;
    drill_fields: [detail*]
  }

  measure: median_session_length {
    group_label: "Percentiles"
    type: median
    sql: ${session_length} ;;
    drill_fields: [detail*]
  }

  measure: session_length_quartile_3 {
    group_label: "Percentiles"
    type: percentile
    percentile: 75
    sql: ${session_length} ;;
    drill_fields: [detail*]
  }

  measure: session_length_95_percentile {
    group_label: "Percentiles"
    type: percentile
    percentile: 95
    sql: ${session_length} ;;
    drill_fields: [detail*]
  }

  measure: max_session_length {
    group_label: "Percentiles"
    type: max
    sql: ${session_length} ;;
    drill_fields: [detail*]
  }

}
