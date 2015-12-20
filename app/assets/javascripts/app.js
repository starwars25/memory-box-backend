(function () {
    var app = angular.module('MemoryBox', ['ngRoute']);


    app.controller('LoginCtrl', [function () {
        this.testVariable = 'Hello, World';
    }]);

    app.controller('RegisterCtrl', [function () {
        this.testVariable = 'Ты пидор';
    }]);

    app.controller('MainCtrl', [function() {

    }]);

    app.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
        $routeProvider.when('/login', {
            templateUrl: 'templates/login.html',
            controller: 'LoginCtrl'
        });
        $routeProvider.when('/register', {
            templateUrl: 'templates/register.html',
            controller: 'RegisterCtrl'
        });
        $routeProvider.when('/', {
            templateUrl: 'templates/main.html',
            controller: 'MainCtrl'
        })
        $routeProvider.otherwise({
            redirectTo: '/'
        })
    }]);
})();