connection: "googlebigqueryconnection"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: default_datagroup {
  sql_trigger: SELECT MAX(timestamp) FROM logfiles.QCID;;
}

explore: demo_qcid {}

explore: qcid {}

explore: qcid_utilization {}
