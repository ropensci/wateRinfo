#' Get timeseries data for specific points on a raster
#' @inheritParams get_timeseries_tsid
#' @param points a matrix or data.frame with coordinates in decimal degrees
#' using the EPSG 4326 coordinate system.
#' It must have the colnames `lat` and `long`.
#' @export
#' @importFrom assertthat assert_that has_name
#' @importFrom dplyr bind_cols bind_rows mutate %>%
#' @importFrom lubridate ymd_hms
#' @importFrom purrr map map2
get_raster_points <- function(
  ts_id = 911010, period = NULL, from = NULL, to = NULL, points,
  datasource = 10, token = NULL
) {
  # check and handle the date/period information
  period_info <- parse_period(from, to, period)
  assert_that(
    inherits(points, "data.frame"), has_name(points, c("long", "lat"))
  )

  query_list <- list(
    type = "queryServices", service = "kisters",
    request = "getRasterToPointValues", ts_id = ts_id, format = "json",
    datasource = datasource, raster_epsg = 4326, metadata = "True",
    raster_x = paste(points$long, collapse = ","),
    raster_y = paste(points$lat, collapse = ",")
  )
  time_series <- call_waterinfo(
    query = c(query_list, period_info), base_url = "hydro", token = token
  )
  map(
    seq_along(points$long),
    function(i) {
      cbind(points[i, c("long", "lat")], ts_id = ts_id)
    }
  ) %>%
    map(`rownames<-`, NULL) -> points_list

  map(time_series$content$data, `colnames<-`, c("timestamp", "value")) %>%
    map(data.frame) %>%
    map2(points_list, bind_cols) %>%
    bind_rows() %>%
    mutate(
      timestamp = ymd_hms(timestamp),
      value = as.numeric(value)
    )
}
