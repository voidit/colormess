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