connection: "googlebigqueryconnection"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: default_datagroup {
  sql_trigger: SELECT MAX(timestamp) FROM logfiles.QCID;;
}

explore: demo_qcid {}

explore: qcid {
  join: qcid_exam_times {
    sql_on: ${qcid.session_uid} = ${qcid_exam_times.session_uid} ;;
    relationship: many_to_one
  }
}

explore: qcid_utilization {}
