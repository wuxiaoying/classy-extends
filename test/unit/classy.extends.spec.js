(function() {
  var app;

  app = angular.module('classyExtendsTest', ['classy', 'classy-extends']);

  app.factory('TestService', function() {
    return function() {
      return 'Test';
    };
  });

  app.factory('TestService2', function() {
    return function() {
      return 'Test2';
    };
  });

  app.factory('TestService3', function() {
    return function() {
      return 'Test3';
    };
  });

  app.classy.controller({
    name: 'ParentController',
    "extends": 'GrandParentController',
    inject: ['$scope', 'TestService'],
    init: function() {
      this.logs = [];
    },
    methods: {
      baseFunc: function() {
        this.logs.push('This only exists on the parent');
      },
      someFunc: function() {
        this.logs.push('Parent');
      }
    }
  });

  app.classy.controller({
    name: 'ChildController',
    "extends": 'ParentController',
    inject: ['$scope', 'TestService2'],
    init: function() {
      this._super(arguments);
    },
    methods: {
      someFunc: function() {
        this._super(arguments);
        this.logs.push('Child');
      },
      getServiceText: function() {
        return this.TestService();
      },
      getServiceText2: function() {
        return this.TestService2();
      }
    }
  });

  app.classy.controller({
    name: 'ChildWithNoMethods',
    "extends": 'ParentController',
    inject: ['$scope']
  });

  app.classy.controller({
    name: 'Child2Controller',
    "extends": 'Parent2Controller',
    inject: ['$scope', 'TestService2'],
    init: function() {
      this._super(arguments);
    },
    methods: {
      someFunc: function() {
        this._super(arguments);
        this.logs.push('Child');
      },
      getServiceText: function() {
        return this.TestService();
      },
      getServiceText2: function() {
        return this.TestService2();
      }
    }
  });

  app.classy.controller({
    name: 'Parent2Controller',
    inject: ['$scope', 'TestService'],
    init: function() {
      this.logs = [];
    },
    methods: {
      baseFunc: function() {
        this.logs.push('This only exists on the parent');
      },
      someFunc: function() {
        this.logs.push('Parent');
      }
    }
  });

  describe('Classy extends (classy-extends.coffee)', function() {
    var childController, controller, scope;
    beforeEach(module('classyExtendsTest'));
    childController = null;
    scope = null;
    controller = null;
    beforeEach(function() {
      inject(function($controller, $rootScope) {
        controller = $controller;
        scope = $rootScope.$new();
        childController = $controller('ChildController', {
          $scope: scope
        });
      });
    });
    it('should call the base class function if the function does not exist on the child class', function() {
      scope.baseFunc();
      expect(childController.logs).toEqual(['This only exists on the parent']);
    });
    it('should be able to call the super function', function() {
      scope.someFunc();
      expect(childController.logs).toEqual(['Parent', 'Child']);
    });
    it('should inject base class dependencies correctly', function() {
      expect(scope.getServiceText()).toBe('Test');
    });
    it('should inject child class dependencies correctly', function() {
      expect(scope.getServiceText2()).toBe('Test2');
    });
    it('should not fail if no methods in child controller', function() {
      var childWithNoMethods;
      childWithNoMethods = controller('ChildWithNoMethods', {
        $scope: scope
      });
    });
  });

  describe('Classy extends - Opposite initialization direction (classy-extends.coffee)', function() {
    var childController, scope;
    beforeEach(module('classyExtendsTest'));
    childController = null;
    scope = null;
    beforeEach(function() {
      inject(function($controller, $rootScope) {
        scope = $rootScope.$new();
        childController = $controller('Child2Controller', {
          $scope: scope
        });
      });
    });
    it('should call the base class function if the function does not exist on the child class', function() {
      scope.baseFunc();
      expect(childController.logs).toEqual(['This only exists on the parent']);
    });
    it('should be able to call the super function', function() {
      scope.someFunc();
      expect(childController.logs).toEqual(['Parent', 'Child']);
    });
    it('should inject base class dependencies correctly', function() {
      expect(scope.getServiceText()).toBe('Test');
    });
    it('should inject child class dependencies correctly', function() {
      expect(scope.getServiceText2()).toBe('Test2');
    });
  });

}).call(this);
