(function() {
  window.Todos = Ember.Application.create({
    LOG_TRANSITIONS: true,
    LOG_TRANSITIONS_INTERNAL: true
  });

  Todos.ApplicationSerializer = DS.RESTSerializer.extend({
    primaryKey: "_id"
  });

  Todos.ApplicationAdapter = DS.RESTAdapter.extend({
    namespace: 'api/v1'
  });

  Todos.TodoController = Ember.ObjectController.extend({
    isEditing: false,
    actions: {
      editTodo: function() {
        return this.set('isEditing', true);
      },
      acceptChanges: function() {
        this.set('isEditing', false);
        if (Ember.isEmpty(this.get('model.title'))) {
          return this.send('removeTodo');
        } else {
          return this.get('model').save();
        }
      },
      removeTodo: function() {
        var todo;
        todo = this.get('model');
        todo.deleteRecord();
        return todo.save();
      }
    },
    isCompleted: (function(key, value) {
      var model;
      model = this.get('model');
      if (value === void 0) {
        return model.get('isCompleted');
      } else {
        model.set('isCompleted', value);
        model.save();
        return value;
      }
    }).property('model.isCompleted')
  });

  Todos.TodosController = Ember.ArrayController.extend({
    actions: {
      createTodo: function() {
        var title, todo;
        title = this.get('newTitle');
        if (!title.trim()) {
          return;
        }
        todo = this.store.createRecord('todo', {
          title: title,
          isCompleted: false
        });
        this.set('newTitle', '');
        return todo.save();
      },
      clearCompleted: function() {
        var completed;
        completed = this.filterProperty('isCompleted', true);
        completed.invoke('deleteRecord');
        return completed.invoke('save');
      }
    },
    remaining: (function() {
      return this.filterProperty('isCompleted', false).get('length');
    }).property('@each.isCompleted'),
    inflection: (function() {
      var remaining;
      remaining = this.get('remaining');
      if (remaining === 1) {
        return "item";
      } else {
        return "items";
      }
    }).property('remaining'),
    hasCompleted: (function() {
      return this.get('completed') > 0;
    }).property('completed'),
    completed: (function() {
      return this.filterProperty('isCompleted', true).get('length');
    }).property('@each.isCompleted'),
    allAreDone: (function(key, value) {
      if (value === void 0) {
        return !!this.get('length') && this.everyProperty('isCompleted', true);
      } else {
        this.setEach('isCompleted', value);
        this.invoke('save');
        return value;
      }
    }).property('@each.isCompleted')
  });

  Todos.Todo = DS.Model.extend({
    title: DS.attr('string'),
    isCompleted: DS.attr('boolean'),
    created: DS.attr('date'),
    modified: DS.attr('date')
  });

  Todos.Router.map(function() {
    this.resource('todos', {
      path: '/'
    }, function() {
      this.route('active');
      return this.route('completed');
    });
    return this.route('missing', {
      path: '/*path'
    });
  });

  Todos.Router.reopen({
    location: 'history'
  });

  Todos.MissingRoute = Ember.Route.extend({
    redirect: function() {
      return this.transitionTo('404');
    }
  });

  Todos.TodosActiveRoute = Ember.Route.extend({
    model: function() {
      return this.store.filter('todo', function(todo) {
        return !todo.get('isCompleted');
      });
    },
    renderTemplate: function(controller) {
      return this.render('todos/index', {
        controller: controller
      });
    }
  });

  Todos.TodosCompletedRoute = Ember.Route.extend({
    model: function() {
      return this.store.filter('todo', function(todo) {
        return todo.get('isCompleted');
      });
    },
    renderTemplate: function(controller) {
      return this.render('todos/index', {
        controller: controller
      });
    }
  });

  Todos.TodosIndexRoute = Ember.Route.extend({
    model: function() {
      return this.modelFor('todos');
    }
  });

  Todos.TodosRoute = Ember.Route.extend({
    model: function() {
      return this.store.find('todo');
    }
  });

  Todos.EditTodoView = Ember.TextField.extend({
    didInsertElement: function() {
      return this.$().focus();
    }
  });

  Ember.Handlebars.helper('edit-todo', Todos.EditTodoView);

}).call(this);

/*
//@ sourceMappingURL=application.js.map
*/