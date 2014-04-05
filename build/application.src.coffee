window.Todos = Ember.Application.create
    LOG_TRANSITIONS: true
    LOG_TRANSITIONS_INTERNAL: true

Todos.ApplicationSerializer = DS.RESTSerializer.extend
    primaryKey: "_id"

Todos.ApplicationAdapter = DS.RESTAdapter.extend
    namespace: 'api/v1'
Todos.TodoController = Ember.ObjectController.extend
    isEditing: false
    
    actions:
        editTodo: ->
            @set 'isEditing', true
        
        acceptChanges: ->
            @set 'isEditing', false
            
            if Ember.isEmpty @get 'model.title'
                @send 'removeTodo'
            else
                @get('model').save()
        
        removeTodo: ->
            todo = @get 'model'
            todo.deleteRecord()
            todo.save()
    
    isCompleted: ((key, value) ->
        model = @get 'model'
        if value is undefined
            # Property being used as a getter
            model.get 'isCompleted'
        else
            # Property being used as  setter
            model.set 'isCompleted', value
            model.save()
            value
    ).property 'model.isCompleted'
Todos.TodosController = Ember.ArrayController.extend
    actions:
        createTodo: ->
            # Get the todo title set by the "New Todo" text field
            title = @get 'newTitle'
            return unless title.trim()
            
            # Create the new Todo model
            todo = @store.createRecord 'todo',
                title: title
                isCompleted: false
            
            # Clear the "New Todo" text field
            @set 'newTitle', ''
            
            # Save the new model
            todo.save()
    
        clearCompleted: ->
            completed = @filterProperty 'isCompleted', true
            completed.invoke 'deleteRecord'
            completed.invoke 'save'
        
    remaining: (->
        @filterProperty('isCompleted', false).get 'length'
    ).property '@each.isCompleted'
    
    inflection: (->
        remaining = @get 'remaining'
        (if remaining is 1 then "item" else "items")
    ).property 'remaining'
    
    hasCompleted: (->
        @get('completed') > 0
    ).property 'completed'
    
    completed: (->
        @filterProperty('isCompleted', true).get 'length'
    ).property '@each.isCompleted'
    
    allAreDone: ((key, value) ->
        if value is undefined
            !!@get('length') and @everyProperty('isCompleted', true)
        else
            @setEach 'isCompleted', value
            @invoke 'save'
            return value
    ).property '@each.isCompleted'
Todos.Todo = DS.Model.extend
    title: DS.attr 'string'
    isCompleted: DS.attr 'boolean'
    created: DS.attr 'date'
    modified: DS.attr 'date'
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
Todos.TodosActiveRoute = Ember.Route.extend
    model: ->
        @store.filter 'todo', (todo) ->
            not todo.get 'isCompleted'
    
    renderTemplate: (controller) ->
        @render 'todos/index', controller: controller
Todos.TodosCompletedRoute = Ember.Route.extend
    model: ->
        @store.filter 'todo', (todo) ->
            todo.get 'isCompleted'
    
    renderTemplate: (controller) ->
        @render 'todos/index', controller: controller
Todos.TodosIndexRoute = Ember.Route.extend
    model: ->
        @modelFor 'todos'
Todos.TodosRoute = Ember.Route.extend
    model: ->
        @store.find 'todo'
Todos.EditTodoView = Ember.TextField.extend
    didInsertElement: ->
        @$().focus()

Ember.Handlebars.helper 'edit-todo', Todos.EditTodoView