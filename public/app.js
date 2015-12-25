var app = angular.module('JunoTravel', []);

app.controller('MainCtrl', ['$scope', function ($scope) {
    $scope.complaints = [{
        theme: 'Explosion on a Railroad',
        content: "Trains can't reach the railway station.",
        priority: 4,
        answered: false,
        createdAt: new Date().setSeconds(new Date().getSeconds() - 60 * 60 * 24),
        stringPriority: 'High',
        priorityClass: 'high',
        category: 0
    }, {
        theme: 'Nuclear Explosion in the Downtown',
        content: "People are afraid and are trying to reach the Vault 111. Organize the evacuation now.",
        priority: 5,
        answered: false,
        createdAt: new Date().setSeconds(new Date().getSeconds() - 60 * 60 * 24 * 14),
        stringPriority: 'Urgent',
        priorityClass: 'urgent',
        category: 0

    }, {
        theme: 'Supemutant invasion on the North',
        content: "Mobilize the troops and secure the City.",
        priority: 3,
        answered: true,
        answer: 'Supermutants defeated.',
        createdAt: new Date().setSeconds(new Date().getSeconds() - 60 * 60 * 24 * 2),
        stringPriority: 'Normal',
        priorityClass: 'normal',
        category: 1

    }];
    $scope.addComplaint = function () {
        var stringPriority, priorityClass;
        switch ($scope.priority.value) {
            case 1:
                stringPriority = 'Very low';
                priorityClass = 'very-low';
                break;
            case 2:
                stringPriority = 'Low';
                priorityClass = 'low';
                break;
            case 3:
                stringPriority = 'Normal';
                priorityClass = 'normal';
                break;
            case 4:
                stringPriority = 'High';
                priorityClass = 'high';
                break;
            case 5:
                stringPriority = 'Urgent';
                priorityClass = 'urgent';
                break;
        }
        $scope.complaints.push({
            theme: $scope.theme,
            content: $scope.content,
            priority: $scope.priority.value,
            answered: false,
            createdAt: new Date(),
            stringPriority: stringPriority,
            priorityClass: priorityClass,
            category: $scope.category.value
        });
        $scope.priority = $scope.options[0];
        $scope.category = $scope.categoryOptions[0];
        $scope.content = '';
        $scope.theme = '';
        $scope.add_complaint.$setPristine();
        $scope.selectedTab = -1;
    };
    $scope.addAnswer = function (complaint) {
        console.log(complaint.temp_answer);
        complaint.answered = true;
        complaint.getAnswerForm = false;

    };
    $scope.sortOptions = [{
        name: 'Priority',
        value: 'priority'
    }, {
        name: 'Time',
        value: 'createdAt'
    }];
    $scope.sort = $scope.sortOptions[0];
    $scope.orderOptions = [{
        name: 'ASC',
        value: '+'
    }, {
        name: 'DESC',
        value: '-'
    }];
    $scope.order = $scope.orderOptions[1];

    $scope.getAnswerForm = function (complaint) {
        for (var i = 0; i < $scope.complaints.length; i++) {
            var other = $scope.complaints[i];
            if (other != complaint) {
                other.getAnswerForm = false;
            }
        }
        complaint.getAnswerForm = true;

    };
    $scope.cancelAnswerForm = function (complaint) {

        complaint.getAnswerForm = false;

    };
    $scope.priority = 1;
    $scope.options = [
        {
            name: 'Very Low',
            value: 1
        },
        {
            name: 'Low',
            value: 2
        },
        {
            name: 'Normal',
            value: 3
        },
        {
            name: 'High',
            value: 4
        },
        {
            name: 'Urgent',
            value: 5
        }
    ];
    $scope.priority = $scope.options[0];
    $scope.categoryOptions = [
        {
            name: 'Airships Service',
            value: 0
        },
        {
            name: 'Planetary Service',
            value: 1
        },
        {
            name: 'Ticket Service',
            value: 2
        },
        {
            name: 'Port Service',
            value: 3
        },
        {
            name: 'Application Troubleshoot',
            value: 4
        },
        {
            name: 'Other',
            value: 5
        }
    ];
    $scope.category = $scope.categoryOptions[0];
    $scope.selectedTab = -1;
    $scope.setSelectedTab = function(tab) {
        $scope.selectedTab = tab;
    };
    $scope.complaintFilter = function (value, index, array) {
        if ($scope.selectedTab === -1) {
            return true;
        }
        return value.category === $scope.selectedTab;
    };
    $scope.tabs = $scope.categoryOptions.slice(0);
    $scope.tabs.unshift({
        name: 'All',
        value: -1
    });
    console.log($scope.tabs);
}]);
