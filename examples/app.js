(function() {
  var app;



  app = angular.module('app', ['classy', 'classy-bind']);

  app.directive('bindClickDirective', function() {
    return {
      restrict: 'E',
      controller: 'BindController',
      template: "<div ng-bind='message'></div>"
    };
  });

  app.classy.controller({
    name: 'BindController',
    inject: ['$scope', '$element'],
    init: function() {
      this.$.message = 'Click me!';
    },
    bind: {
      'click': function(event) {
        var _this = this;
        this.$.$apply(function() {
          _this.$.message = 'Clicked';
        });
      }
    }
  });

}).call(this);
