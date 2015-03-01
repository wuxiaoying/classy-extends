# Test Data

app = angular.module 'classyExtendsTest', [
    'classy'
    'classy-extends'
]

app.factory 'TestService', ->
    ->
        'Test'

app.classy.controller
    name: 'ParentController'

    inject: ['$scope', 'TestService']

    init: ->
        @logs = []
        return

    methods:
        baseFunc: ->
            @logs.push 'This only exists on the parent'
            return

        someFunc: ->
            @logs.push 'Parent'
            return

app.classy.controller
    name: 'ChildController'
    extends: 'ParentController'

    init: ->
        @_super arguments
        return

    methods:
        someFunc: ->
            @_super arguments
            @logs.push 'Child'
            return

        getServiceText: ->
            @TestService()

# Tests

describe 'Classy extends (classy-extends.coffee)', ->
    beforeEach module 'classyExtendsTest'

    childController = null
    scope = null

    beforeEach ->
        inject ($controller, $rootScope) ->
            scope = $rootScope.$new()
            childController = $controller 'ChildController',
                $scope: scope
            return
        return

    it 'should call the base class function if the function does not exist on the child class', ->
        scope.baseFunc()
        expect(childController.logs).toEqual ['This only exists on the parent']
        return

    it 'should be able to call the super function', ->
        scope.someFunc()
        expect(childController.logs).toEqual ['Parent', 'Child']
        return

    it 'should inject base class dependencies correctly', ->
        expect(scope.getServiceText()).toBe 'Test'
        return

    return
