(function () {
    var app = angular.module('MemoryBox', ['ngRoute']);


    app.controller('LoginCtrl', ['$scope', '$http', function ($scope, $http) {
        $scope.submitForm = function() {
            var config = {
                method: 'POST',
                url: '/authentication',
                data: {
                    user: {
                        email: $scope.userEmail,
                        password: $scope.userPassword

                    }
                },
                headers: {
                    "content-type": 'application/json'
                }
            };
            $http(config).then(function success(response) {
                if (response.status === 201) {
                    console.log(response.data);
                }
            }, function error(response) {});
        };
        $scope.userEmail = '';
        $scope.userPassword = '';
    }]);

    app.controller('RegisterCtrl', [function () {
    }]);

    app.controller('MainCtrl', ['$location', function($location) {

    }]);

    app.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
        $routeProvider.when('/login', {
            templateUrl: 'templates/login.html',
            controller: 'LoginCtrl',
            controllerAs: 'login'
        });
        $routeProvider.when('/register', {
            templateUrl: 'templates/register.html',
            controller: 'RegisterCtrl'
        });
        $routeProvider.when('/', {
            templateUrl: 'templates/main.html',
            controller: 'MainCtrl',
            controllerAs: 'main'
        });
        $routeProvider.otherwise({
            redirectTo: '/'
        })
    }]);
})();