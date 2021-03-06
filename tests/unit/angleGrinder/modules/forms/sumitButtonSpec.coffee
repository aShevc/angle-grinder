describe "module: angleGrinder.forms directive: agSubmitButton", ->

  beforeEach module "angleGrinder.forms"

  $scope = null
  element = null
  $http = null

  beforeEach inject ($rootScope, $injector, _$http_) ->
    $http = _$http_

    $scope = $rootScope.$new()
    {element, $scope} = compileTemplate """
      <form name="theForm">
        <ag-submit-button></ag-submit-button>
      </form>
    """, $injector

    element = element.find("button[type=submit]")

  itIsEnabled = ->
    it "is enabled", ->
      expect(element.prop("disabled")).to.be.false

  it "has valid label", ->
    expect(element.text()).to.contain "Save"

  itIsEnabled()

  describe "disabling / enabling", ->

    describe "when the request is in progress", ->
      beforeEach -> $scope.$apply -> $scope.theForm.$saving = true

      it "is disabled", ->
        expect(element.prop("disabled")).to.be.true

      it "changes the button label", ->
        expect(element.text()).to.contain "Save..."

    describe "when the request is not in progress", ->
      beforeEach -> $scope.$apply -> $scope.theForm.$saving = false

      itIsEnabled()
