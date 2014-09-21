app = angular.module 'app', [
    'classy'
    'classy-bind'
]

app.directive 'bindClickDirective', ->
    restrict: 'E'
    controller: 'BindController'
    template: "<div ng-bind='message'></div>"
    
app.classy.controller
    name: 'BindController'
    inject: ['$scope', '$element']
    
    init: ->
        @$.message = 'Click me!'
        return
        
    bind: 
        'click': (event) ->
            @$.$apply =>
                @$.message = 'Clicked'
                return
            return
        
