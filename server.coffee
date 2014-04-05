# Module dependencies.
express   = require 'express'
namespace = require 'express-namespace'
mongoose  = require 'mongoose'
color     = require 'colors'
http      = require 'http'
path      = require 'path'

# Create the express object and set the node environment variable.
app = express()
env = app.settings.env

# Database.
mongo = mongoose.connect 'mongodb://localhost/colormess'

# Import configuration.
config = require("./config/configuration") app, express, env

# All environments
app.configure ->
    # Define view engine with its options.
    app.set "view engine", "jade"
    
    # Parses x-www-form-urlencoded request bodies (and JSON).
    app.use express.urlencoded()
    app.use express.methodOverride()
    app.use express.json()
    
    # Express routing.
    app.use app.router
    
    # Use the favicon middleware.
    app.use express.favicon()

# Define routes.
routes = require("./routes") app

# Put the server into listening mode.
http.createServer(app).listen config.port, ->
    console.log "\n\n---------------------------------------------------------"
    console.log "Express server listening on " + "port %d".bold.red + " in " + "%s mode".bold.green, config.port, env