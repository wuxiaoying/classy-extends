# Test Data

app = angular.module 'classyBindTest', [
    'classy'
    'classy-bind'
]
       
app.directive 'testBind', ->
    restrict: 'E'
    controller: 'BindController'
    template: "<div>blah</div>"
    
app.classy.controller
    name: 'BindController'
    inject: ['$scope', '$element']
    init: ->
        return
        
    bind: 
        'click': (event) ->
            @$.clicked = true
            return
   
# Tests

describe 'Classy bind (classy-bind.coffee)', ->
    beforeEach module 'classyBindTest'
    
    bindController = null
    element = null
    scope = null
    
    beforeEach ->
        inject ($compile, $rootScope) ->
            scope = $rootScope.$new()
            element = $compile("<test-bind></test-bind>") scope
            scope.$digest()
            return
        return
    
    it 'should call handler on click', ->
        expect(scope.clicked).toBeFalsy()
        element[0].click()
        expect(scope.clicked).toBeTruthy()
        return
    return