connection: "googlebigqueryconnection"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: mymodel_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: mymodel_default_datagroup

# NOTE: please see https://looker.com/docs/r/sql/bigquery?version=5.14
# NOTE: for BigQuery specific considerations

explore: demo_qcid {}

explore: qcid {}
