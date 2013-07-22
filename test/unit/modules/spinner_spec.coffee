describe "module: angleGrinder.spinner", ->
  beforeEach module("angleGrinder.spinner")

  describe "service: httpRequestTracker", ->
    $http = null
    httpRequestTracker = null

    beforeEach inject (_httpRequestTracker_, _$http_) ->
      $http = _$http_
      httpRequestTracker = _httpRequestTracker_

    describe "when no requests is progress", ->
      it "does not report pending requests", ->
        expect(httpRequestTracker.hasPendingRequests()).toBeFalsy()

    describe "when some requests are in progress", ->
      beforeEach -> $http.pendingRequests.push({})

      it "reports pending requests", ->
        expect(httpRequestTracker.hasPendingRequests()).toBeTruthy()

    describe "when jquery ajax request is in progress", ->
      beforeEach -> httpRequestTracker.jqueryAjaxRequest = true

      it "reports pending request", ->
        expect(httpRequestTracker.hasPendingRequests()).toBeTruthy()

    describe "jquery AJAX calls", ->
      describe "on ajaxStart", ->
        beforeEach inject ($timeout) ->
          httpRequestTracker.jqueryAjaxRequest = false
          jQuery.event.trigger("ajaxStart")
          $timeout.flush()

        it "it sets #jqueryAjaxRequest flag to true", ->
          expect(httpRequestTracker.jqueryAjaxRequest).toBeTruthy()

      describe "on ajaxStop", ->
        beforeEach inject ($timeout) ->
          httpRequestTracker.jqueryAjaxRequest = true
          jQuery.event.trigger("ajaxStop")
          $timeout.flush()

        it "it sets #jqueryAjaxRequest flag to false", ->
          expect(httpRequestTracker.jqueryAjaxRequest).toBeFalsy()

  describe "controller", ->
    httpRequestTracker = null
    controller = null
    $scope = null

    beforeEach inject ($injector, $rootScope, $controller) ->
      httpRequestTracker = $injector.get("httpRequestTracker")
      $scope = $rootScope.$new()
      controller = $controller "spinner",
        $scope: $scope

    describe "#showSpinner", ->
      describe "when there is a pending request", ->
        beforeEach ->
          spyOn(httpRequestTracker, "hasPendingRequests").andReturn(true)

        it "returns true", ->
          expect($scope.showSpinner()).toBeTruthy()

      describe "otherwise", ->
        beforeEach ->
          spyOn(httpRequestTracker, "hasPendingRequests").andReturn(false)

        it "returns false", ->
          expect($scope.showSpinner()).toBeFalsy()

  describe "directive: spinner", ->
    element = null
    $scope = null

    beforeEach inject ($compile, $rootScope) ->
      $scope = $rootScope.$new()

      element = angular.element """
        <ul>
          <spinner></spinner>
        </ul>
      """
      $compile(element)($scope)
      $scope.$apply()

    showSpinner = (show) ->
      beforeEach -> $scope.$apply -> $scope.showSpinner = -> show

    $spinner = null
    beforeEach -> $spinner = element.find("li.spinner")

    it "renders the spinner", ->
      expect($spinner.length).toBe(1)

    describe "when no requests", ->
      showSpinner false

      it "does not display the animation", ->
        expect($spinner.find("i")).not.toHaveClass "spin"

    describe "when a request is in progress", ->
      showSpinner true

      it "displays the animation", ->
        expect($spinner.find("i")).toHaveClass "spin"
