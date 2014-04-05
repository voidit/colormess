# Default configuration manager
# Inject app and express reference
module.exports = (app, express, env) ->
    
    # Development
    if env is "development"
        require("./development") app, express

    # Production
    if env is "production"
        require("./production") app, express
        
    # Test
    if env is "test"
        require("./test") app, express
    
    # Global configuration
    config =
        "siteName" : "colormess"
        "sessionSecret" : "ofoouxsqllf0wyghmky-zuksvrg3djxtckevw2w-gl7jzo-vmzv-agu-gl2nhmte-gmkxo"
        "uri" : "http://colormess.herokuapp.com"
        "port" : process.env.PORT or 3000
        "debug" : 0
        "profile" : 0
