<?php

function getGroupsData(): array {
    $pdo = new \PDO('sqlite:../data/students.db');
    $groupRequest = <<<GROUP
SELECT strftime('%Y', 'now', '-' || strftime('%s', startDate) || ' seconds', '-1970 years') as course,
groupNumber, id FROM `group`;
GROUP;

    $statement = $pdo->query($groupRequest);
    $groupQuery = $statement->fetchAll();
    $statement->closeCursor();
    return $groupQuery;
}
function getGroupsId(): array {

    $groupsQuery = getGroupsData();
    $groupsId = [];
    foreach ($groupsQuery as $group) {
        $course = (int)ltrim($group['course'], '0') + 1;
        if ($course > 4) $course = 4;
        $fullGroupNumber = $course . '0' . $group['groupNumber'];
        $groupsId[$fullGroupNumber] = $group['id'];
    }

    return $groupsId;
}
function getGroupsNumber(): array {
    $groupsQuery = getGroupsData();
    $groupsNumber = [];
    foreach ($groupsQuery as $group) {
        $course = (int)ltrim($group['course'], '0') + 1;
        if ($course > 4) $course = 4;
        $fullGroupNumber = $course . '0' . $group['groupNumber'];
        $groupsNumber[$group['id']] = $fullGroupNumber;
    }

    return $groupsNumber;
}

function getStudentWithId(int $id): array {
    $studentNumber = $id;
    $pdo = new PDO('sqlite:../data/students.db');
    $statement = $pdo->query("SELECT student.name as name, surname, lastname, sex, birthDate, educationalDirection.name as edName, groupId from student 
    inner join educationalDirection on educationalDirectionId == educationalDirection.id 
    inner join `group` on `group`.id == groupId where studentsNumber == $studentNumber");
    $student = $statement->fetch();
    $statement->closeCursor();
    return $student;
}

function getEducationalDirections(): array {
    $pdo = new PDO('sqlite:../data/students.db');
    $statement = $pdo->query('SELECT id, name from educationalDirection;');
    $educationalDirections = $statement->fetchAll();
    $statement->closeCursor();
    return $educationalDirections;
}

