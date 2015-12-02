# Authors: juangabreil, odiak, wuxiaoying

extends_module = angular.module 'classy-extends', ['classy.core']

 # Dictionary of all classes
classObjs = {}

# Class constructors that are not initialized yet because their base class hasn't initialized.
waitingClassConstructors = {}

extends_module.classy.plugin.controller
    name: 'extends'

    options:
        enabled: true
        super: '_super'

    fnTest: (()->
        fn = undefined
        () ->
            fn ?= if /xyz/.test('function(){xyz;}') then RegExp("\\b#{@options.super}\\b") else /.*/
            return fn)()

    # Based on jeresig class.js
    extend: (classConstructor, classObj, baseClassObj) ->
        processMethods = (baseClassMethods, classMethods) =>
            return if not classMethods
            for prop of baseClassMethods
                if typeof classMethods[prop] == 'undefined'
                    classMethods[prop] = classConstructor::[prop] = baseClassMethods[prop]
                else if angular.isFunction(classMethods[prop]) and \
                        @fnTest().test(classMethods[prop]) and \
                        prop != 'constructor'
                    classMethods[prop] = classConstructor::[prop] = ((name, fn, parentName) ->
                        ->
                            tmp = @[parentName]
                            self = @
                            @[parentName] = (args) ->
                                baseClassMethods[name].apply(self, args || [])

                            ret = fn.apply(@, arguments)
                            @[parentName] = tmp
                            ret
                    )(prop, classMethods[prop], @options.super)

        processMethods baseClassObj.methods, classObj.methods
        processMethods baseClassObj.watch, classObj.watch
        processMethods baseClassObj, classObj

        # Make sure dependencies are injected correctly for base class and current class.
        isInitialized = classConstructor.__classDepNames?

        for key, val of baseClassObj.inject
            classObj.inject.push val
            if isInitialized
                if val not in classConstructor.$inject
                    # A bit hacky here, because the local inject messes with the class dep inject sequence
                    lenInject = classConstructor.$inject.length
                    classConstructor.$inject.push val
                    extra = ([0...lenInject - classConstructor.__classDepNames.length].map (x) => "")
                    classConstructor.__classDepNames.push extra...
                    classConstructor.__classDepNames.push val

        return

    preInitBefore: (classConstructor, classObj, module) ->
        # If the base class already exists then use it,
        # Otherwise, put the class in the waiting class constructors dictionary until the base class is initialized.
        if baseClass = classObj.extends
            baseClassObj = classObjs[baseClass]
            if baseClassObj
                @extend classConstructor, classObj, baseClassObj
            else
                waitingClassConstructors[classObj.name] = classConstructor

        # Register class with classObjs.
        classObjs[classObj.name] = classObj

        # Check to see if a waiting class constructor is waiting on this class as its base.
        for className, waitingClassConstructor of waitingClassConstructors
            waitingClassObj = classObjs[className]
            if waitingClassObj.extends == classObj.name
                @extend waitingClassConstructor, waitingClassObj, classObj
        return
