# This is where all routes are to be
# included into the application.
module.exports = (app) ->
    
    app.namespace '/api', ->
        require('./v1/todos') app
    
    require('./static') app