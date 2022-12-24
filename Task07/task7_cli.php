<?php


$pdo = new PDO('sqlite:students.db');

$groupRequest = <<<GROUP
SELECT strftime('%Y', 'now', '-' || strftime('%s', startDate) || ' seconds', '-1970 years') as course,
groupNumber, id FROM `group`;
GROUP;

$statement = $pdo->query($groupRequest);
$groupQuery = $statement->fetchAll();
$statement->closeCursor();

$groupsId = [];
print("Доступные группы:\n");
foreach ($groupQuery as $group) {
    $course = (int)ltrim($group['course'], '0') + 1;
    if ($course > 4) $course = 4;
    $fullGroupNumber = $course . '0' . $group['groupNumber'];
    $groupsId[$fullGroupNumber] = $group['id'];
    print($fullGroupNumber . "\n");
}

$group = readline('Enter number of group: ');

$request = <<<QUERY
SELECT studentsNumber, student.name, surname, lastname, sex, birthDate, groupId,
educationalDirection.name as edName from student inner join `group` on groupId == `group`.id
                          inner join educationalDirection on educationalDirectionId == educationalDirection.id
QUERY;
if ($group) {
    $request .= " where groupId == {$groupsId[$group]}";

}

$request .= ' order by startDate desc, groupNumber, surname, student.name, lastname;';

$statement = $pdo->query($request);
$students = $statement->fetchAll();
$statement->closeCursor();
print('Гр. |            ФИО            |   Пол   | Дата рождения |   Направление обучения   | Студенческий' . "\n");
foreach ($students as $student) {
    $groupVal = $group;
    if ($groupVal === '') {
        $groupVal = array_search($student['groupId'], $groupsId);
    }
    print($groupVal);
    print(' | ');
    print($student['name'] . ' ' . $student['surname'] . ' ' . $student['lastname']);
    print(' | ');
    print($student['sex'] . ' | '  . $student['birthDate'] . ' | ' . $student['edName']);
    print(' | ');
    print($student['studentsNumber']);
    print("\n");
}




