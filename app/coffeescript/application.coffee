window.Todos = Ember.Application.create
    LOG_TRANSITIONS: true
    LOG_TRANSITIONS_INTERNAL: true

Todos.ApplicationSerializer = DS.RESTSerializer.extend
    primaryKey: "_id"

Todos.ApplicationAdapter = DS.RESTAdapter.extend
    namespace: 'api/v1'