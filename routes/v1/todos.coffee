#
# Todos Routes
#
module.exports = (app) ->
    {TodoModel} = require '../../models'
    
    app.namespace '/v1', ->
        app.get '/todos', (req, res) ->
            TodoModel.find (err, todos) ->
                unless err
                    res.json todos: todos
                else
                    console.log err

        app.post '/todos', (req, res) ->
            console.log "POST: #{JSON.stringify(req.body)}"
            todo = new TodoModel
                title: req.body.todo.title
                isCompleted: req.body.todo.isCompleted
    
            todo.save (err) ->
                unless err
                    console.log "created"
                else
                    console.log err
                res.json todo: todo

        app.get '/todos/:id', (req, res) ->
            TodoModel.findById req.params.id, (err, todo) ->
                unless err
                    res.json todo: todo
                else
                    console.log err

        app.put '/todos/:id', (req, res) ->
            console.log "PUT: #{JSON.stringify(req.body)}"
            TodoModel.findById req.params.id, (err, todo) ->
                todo.title = req.body.todo.title
                todo.isCompleted = req.body.todo.isCompleted
                todo.save (err) ->
                    unless err
                        console.log "updated"
                    else
                        console.log err
                    res.json todo: todo

        app.delete '/todos/:id', (req, res) ->
            TodoModel.findById req.params.id, (err, todo) ->
                todo.remove (err) ->
                    unless err
                        console.log "removed"
                    else
                        console.log err
    
        app.put '/todos', (req, res) ->
            console.log "is Array req.body.todos"
            console.log Array.isArray req.body.todos
            console.log "PUT: #{req.body.todos}"
        
            if Array.isArray req.body.todos
                len = req.body.todos.length
            
            i = 0
            while i < len
                console.log "UPDATE todo by id:"
                for id of req.body.todos[i]
                    console.log id
                    TodoModel.update
                        _id: id
                    , req.body.todos[i][id], (err, numAffected) ->
                        if err
                            console.log "Error on update"
                            console.log err
                        else
                            console.log "updated num: " + numAffected
            i++
            res.json todos: req.body.todos
    
        app.delete '/todos', (req, res) ->
            TodoModel.remove (err) ->
                unless err
                    console.log "removed"
                else
                  console.log err