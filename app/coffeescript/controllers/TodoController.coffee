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