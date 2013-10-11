# The entry point for the application

app = angular.module("angleGrinder", [
  "ngRoute"

  "angleGrinder.resources"
  "angleGrinder.docs"

  "angleGrinder.common"
  "angleGrinder.gridz"
  "angleGrinder.forms"
  "angleGrinder.alerts"
  "angleGrinder.dataGenerator"
  "angleGrinder.spinner"
])

# Sample `pathWithContext` configuration block
app.config [
  "pathWithContextProvider", (pathWithContextProvider) ->
    contextPath = $("body").data("context-path")
    pathWithContextProvider.setContextPath(contextPath) if contextPath?
]

# Intercepts all HTTP errors and displays a flash message
app.factory "httpErrorsInterceptor", [
  "$injector", "$q", "alerts", ($injector, $q, alerts) ->
    (promise) ->
      $http = $injector.get("$http")

      onError = (response) ->
        errorMessage = response.data?.error || "Unexpected HTTP error"

        # skip validation errors
        alerts.error(errorMessage) if response.status isnt 422

        $q.reject(response)

      promise.then(null, onError)
]

# Catch all jquery xhr errors
app.run [
  "$log", "alerts", ($log, alerts) ->
    $(document).ajaxError (event, jqxhr, settings, exception) ->
      $log.error("Network error:", event, jqxhr, settings, exception)
      alerts.error(exception)
]

$ ->
  # Disable certain links in docs
  $("section [href^=#]").click (e) ->
    e.preventDefault()

  # side bar
  setTimeout (->
    $(".bs-docs-sidenav").affix offset:
      top: ->
        (if $(window).width() <= 980 then 140 else 160)

      bottom: 270

  ), 100
