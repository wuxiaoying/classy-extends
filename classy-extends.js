(function() {
  var classObjs, extends_module, waitingClassConstructors,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  extends_module = angular.module('classy-extends', ['classy.core']);

  classObjs = {};

  waitingClassConstructors = {};

  extends_module.classy.plugin.controller({
    name: 'extends',
    options: {
      enabled: true,
      "super": '_super'
    },
    fnTest: (function() {
      var fn;
      fn = void 0;
      return function() {
        if (fn == null) {
          fn = /xyz/.test('function(){xyz;}') ? RegExp("\\b" + this.options["super"] + "\\b") : /.*/;
        }
        return fn;
      };
    })(),
    extend: function(classConstructor, classObj, baseClassObj) {
      var dep, isInitialized, key, processMethods, val, _i, _len, _ref, _ref1;
      processMethods = (function(_this) {
        return function(baseClassMethods, classMethods) {
          var prop, _results;
          _results = [];
          for (prop in baseClassMethods) {
            if (typeof classMethods[prop] === 'undefined') {
              _results.push(classMethods[prop] = classConstructor.prototype[prop] = baseClassMethods[prop]);
            } else if (angular.isFunction(classMethods[prop]) && _this.fnTest().test(classMethods[prop]) && prop !== 'constructor') {
              _results.push(classMethods[prop] = classConstructor.prototype[prop] = (function(name, fn, parentName) {
                return function() {
                  var ret, self, tmp;
                  tmp = this[parentName];
                  self = this;
                  this[parentName] = function(args) {
                    return baseClassMethods[name].apply(self, args || []);
                  };
                  ret = fn.apply(this, arguments);
                  this[parentName] = tmp;
                  return ret;
                };
              })(prop, classMethods[prop], _this.options["super"]));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        };
      })(this);
      processMethods(baseClassObj.methods, classObj.methods);
      processMethods(baseClassObj, classObj);
      isInitialized = classConstructor.__classDepNames != null;
      if (isInitialized && (classConstructor.__classyControllerInjectObject == null)) {
        classConstructor.__classyControllerInjectObject = {};
        _ref = classConstructor.__classDepNames;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          dep = _ref[_i];
          classConstructor.__classyControllerInjectObject[dep] = '.';
        }
      }
      _ref1 = baseClassObj.inject;
      for (key in _ref1) {
        val = _ref1[key];
        classObj.inject[key] = val;
        if (isInitialized) {
          if (__indexOf.call(classConstructor.$inject, val) < 0) {
            classConstructor.$inject.push(val);
            classConstructor.__classDepNames.push(val);
          }
          classConstructor.__classyControllerInjectObject[key] = val;
        }
      }
    },
    preInitBefore: function(classConstructor, classObj, module) {
      var baseClass, baseClassObj, className, waitingClassConstructor, waitingClassObj;
      if (baseClass = classObj["extends"]) {
        baseClassObj = classObjs[baseClass];
        if (baseClassObj) {
          this.extend(classConstructor, classObj, baseClassObj);
        } else {
          waitingClassConstructors[classObj.name] = classConstructor;
        }
      }
      classObjs[classObj.name] = classObj;
      for (className in waitingClassConstructors) {
        waitingClassConstructor = waitingClassConstructors[className];
        waitingClassObj = classObjs[className];
        if (waitingClassObj["extends"] === classObj.name) {
          this.extend(waitingClassConstructor, waitingClassObj, classObj);
        }
      }
    }
  });

}).call(this);
