context("waterinfo_call")

test_that("base url is valid", {
  query <- list()
  expect_error(call_waterinfo(query, base_url = "www"),
    regexp = "Base url should be download or pro"
  )
})

test_that("wrong token object", {
  query <- list()
  expect_error(call_waterinfo(query, token = "3AGZ"))
})

test_that("non existing tsid to API", {
  query <- list(
    type = "queryServices", service = "kisters",
    request = "getTimeseriesvalues",
    ts_id = "notsid", format = "json",
    datasource = 1
  )
  expect_error(call_waterinfo(query),
    regexp = "Waterinfo API request failed.*InvalidParameterValue"
  )
})

# tackle specific case when error is thrown by the server on missing datasource
test_that("datasource not included in the API call", {
  query <- list(
    type = "queryServices", service = "kisters",
    request = "getTimeseriesvalues",
    ts_id = "5156042", format = "json"
  )
  expect_error(call_waterinfo(query),
               regexp = "Waterinfo API request failed.*InvalidParameterValue.*Could not find a datasource"
  )
})

tomcat_html_response <- "<!doctype html><html lang=\"en\"><head><title>HTTP Status 500 – Internal Server Error</title><style type=\"text/css\">H1 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:22px;} H2 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:16px;} H3 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:14px;} BODY {font-family:Tahoma,Arial,sans-serif;color:black;background-color:white;} B {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;} P {font-family:Tahoma,Arial,sans-serif;background:white;color:black;font-size:12px;}A {color : black;}A.name {color : black;}.line {height: 1px; background-color: #525D76; border: none;}</style></head><body><h1>HTTP Status 500 – Internal Server Error</h1><hr class=\"line\" /><p><b>Type</b> Exception Report</p><p><b>Description</b> The server encountered an unexpected condition that prevented it from fulfilling the request.</p><p><b>Exception</b></p><pre>java.lang.NullPointerException\r\n\tde.kisters.kiwis.services.kiqs.merged.MergedQueryServices.init(MergedQueryServices.java:129)\r\n\tde.kisters.kiwis.services.KistersHandler.handleKistersRequest(KistersHandler.java:148)\r\n\tde.kisters.kiwis.main.KiWIS.doKVP(KiWIS.java:1249)\r\n\tde.kisters.kiwis.main.KiWIS.doGet(KiWIS.java:583)\r\n\tjavax.servlet.http.HttpServlet.service(HttpServlet.java:622)\r\n\tjavax.servlet.http.HttpServlet.service(HttpServlet.java:729)\r\n\torg.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:52)\r\n</pre><p><b>Note</b> The full stack trace of the root cause is available in the server logs.</p><hr class=\"line\" /><h3>Apache Tomcat</h3></body></html>"

test_that("tomcat error message content", {
  query <- list(
    type = "queryServices", service = "kisters",
    request = "getTimeseriesvalues",
    ts_id = "notsid", format = "json"
  )
  base <- waterinfo_base()
  res <- GET(base, query = query)
  expect_identical(content(res, "text", encoding = "UTF-8"),
                   tomcat_html_response)
})


test_that("add call to waterinfo explicitly to the print output", {
  skip_on_cran()

  query <- list(
    type = "queryServices", service = "kisters",
    request = "getTimeseriesvalues",
    ts_id = "5156042", format = "json", datasource = 1
  )
  response <- call_waterinfo(query)
  raw_call_info <- paste0("Waterinfo API query applied: type=queryServices&",
                          "service=kisters&request=getTimeseriesvalues&",
                          "ts_id=5156042&format=json&datasource=1")
  expect_equal(capture.output(print(response))[1], raw_call_info)
})
