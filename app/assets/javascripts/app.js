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

    app.factory('$common', ['$cookies', '$location', '$http', function($cookies, $location, $http) {
        return {
            redirectIfNotLoggedIn: function() {
                if ($cookies.get('token') === undefined || $cookies.get('user-id') === undefined) {
                    $location.path('/login');
                }

            },
            equalHeights: function() {
                var sideHeight = $('.angular-side').height();
                var mainHeight = $('.angular-main').height();
                if (sideHeight > mainHeight) {
                    $('.angular-main').height(sideHeight);
                } else {
                    $('.angular-side').height(mainHeight);

                }
            },
            getUser: function(scope, finish) {
                scope.user = {};
                var request = {
                    method: 'GET',
                    url: '/users/' + $cookies.get('user-id'),
                    headers: {
                        "token": $cookies.get('token'),
                        "user-id": $cookies.get('user-id')
                    }
                };
                $http(request).then(function (response) {
                    if(response.status === 200) {
                        scope.user.name = response.data.name;
                        scope.user.avatar = response.data.avatar.avatar.url;
                        finish();
                    }
                }, function (response) {

                });

            },
            concatStrings: function(array) {
                var output = '';
                for(var i = 0; i < array.length; i++) {
                    output += array[i];
                    if (i != array.length - 1) {
                        output += ', '
                    }
                }
                return output;
            }
        }
    }]);

    app.controller('MainCtrl', ['$location', '$scope', '$timeout', '$cookies', '$http', '$common', function($location, $scope, $timeout, $cookies, $http, $common) {
        $common.redirectIfNotLoggedIn();
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
                    for(var i = 0; i < response.data.boxes.length; i++) {
                        getUsersInBox(response.data.boxes[i]);
                    }
                }
            }, function (response) {

            });
        };


        var getUsersInBox = function (box) {
            box.users = [];
            for(var i = 0; i < box.users_ids.length; i++) {
                getUser(box.users_ids[i], function(data) {
                     box.users.push(data.name);
                });
            }
        };
        var getUser = function(id, complete) {
            var request = {
                method: 'GET',
                url: '/users/' + id,
                headers: {
                    "token": $cookies.get('token'),
                    "user-id": $cookies.get('user-id')
                }
            };
            $http(request).then(function (response) {
                if(response.status === 200) {
                    complete(response.data);
                }
            }, function (response) {

            });

        };

        $scope.listUsers = $common.concatStrings;

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

    app.controller('BoxCtrl', ['$scope', '$cookies', '$http', '$location', '$common', '$routeParams', '$timeout', function($scope, $cookies, $http, $location, $common, $routeParams, $timeout) {
        $common.redirectIfNotLoggedIn();
        $common.getUser($scope, function() {
            //$timeout(function () {
            //    $common.equalHeights();
            //}, 100)
        });
        var request = {
            method: 'GET',
            url: '/boxes/' + $routeParams.id,
            headers: {
                "token": $cookies.get('token'),
                "user-id": $cookies.get('user-id')
            }
        };
        $http(request).then(function(response) {
            if (response.status === 200) {
                $scope.box = response.data;
                console.log(response.data);
                $timeout(function() {
                    $common.equalHeights();
                }, 20);
            }
        }, function(response) {

        });
    }]);

    app.controller('ArgumentCtrl', ['$scope', '$cookies', '$http', '$location', '$common', '$routeParams', '$timeout', function($scope, $cookies, $http, $location, $common, $routeParams, $timeout) {
        $common.redirectIfNotLoggedIn();
        var userLoaded = false;
        var argumentLoaded = false;
        var loaded = false;
        $common.getUser($scope, function() {
            userLoaded = true;
            if(!loaded && argumentLoaded) {

                $timeout(function() {
                    $common.equalHeights();
                    loaded = true;
                }, 50);
            }


        });
        var request = {
            method: 'GET',
            url: '/arguments/' + $routeParams.id,
            headers: {
                "token": $cookies.get('token'),
                "user-id": $cookies.get('user-id')
            }
        };
        $http(request).then(function(response) {

            if (response.status === 200) {
                $scope.argument = response.data;
                argumentLoaded = true;
                console.log(response.data);
                if(!loaded && userLoaded) {
                    $timeout(function() {
                        $common.equalHeights();
                        loaded = true;
                    }, 50);
                }

            }
        }, function(response) {

        });

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
    app.directive('pageHeader', function() {
        return {
            restrict: 'E',
            templateUrl: 'templates/page-header.html',
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
        $routeProvider.when('/boxes/:id', {
            templateUrl: 'templates/box.html',
            controller: 'BoxCtrl'
        });
        $routeProvider.when('/arguments/:id', {
            templateUrl: 'templates/argument.html',
            controller: 'ArgumentCtrl'
        });
        $routeProvider.otherwise({
            redirectTo: '/'
        });
        var expires = new Date();
        expires.setSeconds(expires.getSeconds() + 60*60*24*14);
        $cookiesProvider.defaults.expires = expires;
    }]);
})();