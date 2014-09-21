# Authors: juangabreil, odiak 

extends_module = angular.module 'classy-extends', ['classy-core']

extends_module.classy.plugin.controller
    name: 'extends'
 
    # Dictionary of all classes
    classObjs: {}
    
    # Class constructors that are not initialized yet because their base class hasn't initialized. 
    waitingClassConstructors: {}
 
    options:
        enabled: true
        super: '_super'
 
    fnTest: (()->
        fn = undefined
        () ->
            fn ?= if /xyz/.test('function(){xyz;}') then RegExp("\\b#{@options.super}\\b") else /.*/
            return fn)()
 
    convertInject: (classObj) ->
        if angular.isArray classObj.inject
            _inject = {}
            for i in classObj.inject
                _inject[i] = '.'
            classObj.inject = _inject
 
    # Based on eresig class.js
    extend: (classConstructor, classObj, baseClassObj) ->
        for prop of baseClassObj
            if typeof classObj[prop] == 'undefined'
                classObj[prop] = classConstructor::[prop] = baseClassObj[prop]
            else if angular.isFunction(classObj[prop]) and \
                    @fnTest().test(classObj[prop]) and \
                    prop != 'constructor'
                classObj[prop] = classConstructor::[prop] = ((name, fn, parentName) ->
                    ->
                        tmp = @[parentName]
                        self = @
                        @[parentName] = (args) ->
                            baseClassObj[name].apply(self, args || [])
                            
                        ret = fn.apply(@, arguments)
                        @[parentName] = tmp
                        ret
                )(prop, classObj[prop], @options.super)
 
        # Make sure dependencies are injected correctly for base class and current class. 
        @convertInject classObj
        @convertInject baseClassObj
        isInitialized = classConstructor.__classDepNames?
 
        if isInitialized and not classConstructor.__classyControllerInjectObject?
            classConstructor.__classyControllerInjectObject = {}
            for dep in classConstructor.__classDepNames
                classConstructor.__classyControllerInjectObject[dep] = '.'
 
        for key, val of baseClassObj.inject
            classObj.inject[key] = val
            if isInitialized
                if key not in classConstructor.$inject
                    classConstructor.$inject.push key
                    classConstructor.__classDepNames.push key
                classConstructor.__classyControllerInjectObject[key] = val
        return
 
    preInitBefore: (classConstructor, classObj, module) ->
        # If the base class already exists then use it, 
        # Otherwise, put the class in the waiting class constructors dictionary until the base class is initialized.
        if classObj.extends
            baseClassObj = @classObjs[classObj.extends]
            if baseClassObj
                @extend classConstructor, classObj, baseClassObj
            else
                @waitingClassConstructors[classObj.name] = classConstructor
 
        # Register class with classObjs.
        @classObjs[classObj.name] = classObj
 
        # Check to see if a waiting class constructor is waiting on this class as its base. 
        for className, waitingClassConstructor of @waitingClassConstructors
            waitingClassObj = @classObjs[className]
            if waitingClassObj.extends == classObj.name
                @extend waitingClassConstructor, waitingClassObj, classObj
        return