bind_module = angular.module 'classy-bind', ['classy-core']

bind_module.classy.plugin.controller
    name: 'bind'

    options:
        enabled: true

    isActive: (klass, deps) ->
        if @options.enabled and angular.isObject(klass.bind)
            if !deps.$element
                throw new Error "You need to inject `$element` to use the watch object"
                return false

            return true

    postInit: (klass, deps, module) ->
        if !@isActive(klass, deps) then return

        
        for key, fn of klass.bind
            deps.$element.bind key, angular.bind klass, fn
        return