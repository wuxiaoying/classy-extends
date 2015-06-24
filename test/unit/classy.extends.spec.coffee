# Test Data

app = angular.module 'classyExtendsTest', [
    'classy'
    'classy-extends'
]

app.factory 'TestService', ->
    ->
        'Test'

app.factory 'TestService2', ->
    ->
        'Test2'

app.factory 'TestService3', ->
    ->
        'Test3'

app.classy.controller
    name: 'ParentController'
    extends: 'GrandParentController'

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

    inject: ['$scope', 'TestService2']

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

        getServiceText2: ->
            @TestService2()

app.classy.controller
    name: 'ChildWithNoMethods'
    extends: 'ParentController'
    inject: ['$scope']

app.classy.controller
    name: 'Child2Controller'
    extends: 'Parent2Controller'

    inject: ['$scope', 'TestService2']

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

        getServiceText2: ->
            @TestService2()

app.classy.controller
    name: 'Parent2Controller'

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

# Tests

describe 'Classy extends (classy-extends.coffee)', ->
    beforeEach module 'classyExtendsTest'

    childController = null
    scope = null
    controller = null

    beforeEach ->
        inject ($controller, $rootScope) ->
            controller = $controller
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

    it 'should inject child class dependencies correctly', ->
        expect(scope.getServiceText2()).toBe 'Test2'
        return

    it 'should not fail if no methods in child controller', ->
        childWithNoMethods = controller 'ChildWithNoMethods',
          $scope: scope

        return

    return

describe 'Classy extends - Opposite initialization direction (classy-extends.coffee)', ->
    beforeEach module 'classyExtendsTest'
    childController = null
    scope = null

    beforeEach ->
        inject ($controller, $rootScope) ->
            scope = $rootScope.$new()
            childController = $controller 'Child2Controller',
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

    it 'should inject child class dependencies correctly', ->
        expect(scope.getServiceText2()).toBe 'Test2'
        return
    return
