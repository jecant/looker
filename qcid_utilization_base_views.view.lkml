view: qcid_sessions {
  derived_table: {
    sql:
      SELECT SessionUID
        ,ExamGroupName,ExposureTypeName,InstitutionName,Solution,ExamGroupNameEN,ExposureTypeNameEN,ExamGroupNameENClustered
        ,MIN(CASE WHEN Action='Switch To Open Session' THEN timestamp ELSE NULL END) AS session_start
        ,MAX(CASE WHEN Action='Close And Send All' THEN timestamp ELSE NULL END) AS session_end
      FROM ${qcid.SQL_TABLE_NAME}
      GROUP BY SessionUID
        ,ExamGroupName,ExposureTypeName,InstitutionName,Solution,ExamGroupNameEN,ExposureTypeNameEN,ExamGroupNameENClustered;;
  }
}

view: times_of_day {
  derived_table: {
    sql:  SELECT FORMAT_TIMESTAMP('%H:%M',TIMESTAMP_ADD(TIMESTAMP('2010-01-01 00:00:00'), INTERVAL 5*steps minute)) as time_of_day_string
      ,TIMESTAMP_ADD(TIMESTAMP('2010-01-01 00:00:00'), INTERVAL 5*steps minute) as time_of_day_ts
    FROM (SELECT steps
    FROM UNNEST(GENERATE_ARRAY(0,287,1)) as steps);;
  }
}

view: qcid_utilization_base {
  derived_table: {
    sql:
      SELECT
        tod.time_of_day_string,ExamGroupName,ExposureTypeName,InstitutionName,Solution,ExamGroupNameEN,ExposureTypeNameEN,ExamGroupNameENClustered
        ,COUNT(distinct case
          when FORMAT_TIMESTAMP('%H:%M',qs.session_start) >=tod.time_of_day_string AND FORMAT_TIMESTAMP('%H:%M',qs.session_start) < FORMAT_TIMESTAMP('%H:%M',TIMESTAMP_ADD(tod.time_of_day_ts, INTERVAL 5 minute))
            THEN CAST(qs.session_start as date)
          when FORMAT_TIMESTAMP('%H:%M',qs.session_end) >=tod.time_of_day_string AND FORMAT_TIMESTAMP('%H:%M',qs.session_end) < FORMAT_TIMESTAMP('%H:%M',TIMESTAMP_ADD(tod.time_of_day_ts, INTERVAL 5 minute))
            THEN CAST(qs.session_start as date)
          ELSE NULL END) as number_of_utilised_days
        ,COUNT(distinct CAST(qs.session_start as date)) as number_of_days
      FROM
      ${qcid_sessions.SQL_TABLE_NAME} qs
      CROSS JOIN ${times_of_day.SQL_TABLE_NAME} tod
      GROUP BY tod.time_of_day_string,ExamGroupName,ExposureTypeName,InstitutionName,Solution,ExamGroupNameEN,ExposureTypeNameEN,ExamGroupNameENClustered;;
  }
}
