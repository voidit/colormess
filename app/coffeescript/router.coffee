Todos.Router.map ->
    @resource 'todos', path: '/', ->
        @route 'active'
        @route 'completed'
        
    @route 'missing', path: '/*path'

Todos.Router.reopen
    location: 'history'

Todos.MissingRoute = Ember.Route.extend
    redirect: ->
        @transitionTo '404'