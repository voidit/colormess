Todos.TodosCompletedRoute = Ember.Route.extend
    model: ->
        @store.filter 'todo', (todo) ->
            todo.get 'isCompleted'
    
    renderTemplate: (controller) ->
        @render 'todos/index', controller: controller