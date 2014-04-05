mongoose = require 'mongoose'

#
# Todos Model
#
Schema = mongoose.Schema

Todo = new Schema
    title: type: String, required: true
    isCompleted: type: Boolean, default: false
    created: type: Date, default: Date.now
    modified: type: Date, default: Date.now

exports.Schema = mongoose.model 'Todo', Todo