#
# Static Routes
#
module.exports = (app) ->
    app.get '/*', (req, res) ->
        res.render 'index'