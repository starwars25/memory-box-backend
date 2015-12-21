(function () {
    var app = angular.module('MemoryBox', ['ngRoute', 'ngCookies']);


    app.controller('LoginCtrl', ['$scope', '$http', '$cookies', '$location', function ($scope, $http, $cookies, $location) {
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
                    $cookies.put('token', response.data.token);
                    $cookies.put('user-id', response.data.user_id);
                    $location.path('/');
                } else {
                    $scope.userEmail = '';
                    $scope.userPassword = '';
                }
            }, function error(response) {});
        };
        $scope.userEmail = '';
        $scope.userPassword = '';
    }]);

    app.controller('RegisterCtrl', [function () {
    }]);

    app.controller('MainCtrl', ['$location', '$scope', '$timeout', '$cookies', '$http', function($location, $scope, $timeout, $cookies, $http) {
        var equalHeights = function() {
            var sideHeight = $('.angular-side').height();
            var mainHeight = $('.angular-main').height();
            if (sideHeight > mainHeight) {
                $('.angular-main').height(sideHeight);
            } else {
                $('.angular-side').height(mainHeight);

            }
        };
        var redirectIfNotLoggedInt = function() {
            if ($cookies.get('token') === undefined || $cookies.get('user-id') === undefined) {
                $location.path('/login');
            }
        };
        redirectIfNotLoggedInt();
        $timeout(function() {
           //equalHeights();
        }, 10);
        $scope.boxes = undefined;
        var getInfo = function() {
            console.log('get info');
            var request = {
                method: 'GET',
                url: '/users/' + $cookies.get('user-id'),
                headers: {
                    "token": $cookies.get('token'),
                    "user-id": $cookies.get('user-id')
                }
            };
            $scope.user = {};
            $http(request).then(function (response) {
                if(response.status === 200) {
                    console.log(response.data);
                    $scope.boxes = response.data.boxes;
                    $scope.user.name = response.data.name;
                    $scope.user.avatar = response.data.avatar.avatar.url;
                    $timeout(function() {
                        equalHeights();
                    }, 10);
                }
            }, function (response) {

            });
        };
        getInfo();
    }]);

    app.controller('HeaderCtrl', ['$scope', '$cookies', '$location', function($scope, $cookies, $location) {
        $scope.loggedIn = function() {
            return !($cookies.get('token') === undefined || $cookies.get('user-id') === undefined)
        };
        $scope.logOut = function () {
            $cookies.remove('token');
            $cookies.remove('user-id');
            $location.path('/login');
        };
    }]);

    app.directive('sideBar', function() {
        return {
            restrict: 'A',
            templateUrl: 'templates/side-bar.html'
        }
    });

    app.directive('boxes', function() {
        return {
            restrict: 'A',
            templateUrl: 'templates/boxes.html'
        }
    });
    app.directive('header', function() {
        return {
            restrict: 'E',
            templateUrl: 'templates/header.html',
            controller: 'HeaderCtrl'
        }
    });

    app.config(['$routeProvider', '$locationProvider', '$cookiesProvider', function($routeProvider, $locationProvider, $cookiesProvider) {
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
        });
        var expires = new Date();
        expires.setSeconds(expires.getSeconds() + 60*60*24*14);
        $cookiesProvider.defaults.expires = expires;
    }]);
})();