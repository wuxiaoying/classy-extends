(function() {
  var app;

  app = angular.module('classyBindTest', ['classy', 'classy-bind']);

  app.directive('testBind', function() {
    return {
      restrict: 'E',
      controller: 'BindController',
      template: "<div>blah</div>"
    };
  });

  app.classy.controller({
    name: 'BindController',
    inject: ['$scope', '$element'],
    init: function() {},
    bind: {
      'click': function(event) {
        this.$.clicked = true;
      }
    }
  });

  describe('Classy bind (classy-bind.coffee)', function() {
    var bindController, element, scope;
    beforeEach(module('classyBindTest'));
    bindController = null;
    element = null;
    scope = null;
    beforeEach(function() {
      inject(function($compile, $rootScope) {
        scope = $rootScope.$new();
        element = $compile("<test-bind></test-bind>")(scope);
        scope.$digest();
      });
    });
    it('should call handler on click', function() {
      expect(scope.clicked).toBeFalsy();
      element[0].click();
      expect(scope.clicked).toBeTruthy();
    });
  });

}).call(this);
