TodoModel = require './todos'

class Model
    constructor: (@name, @module) ->
        @collectionName = @name
        @schema = module.Schema

    toString: ->
        "Model #{@name}"

exports.TodoModel = new Model("todos", TodoModel).schema
