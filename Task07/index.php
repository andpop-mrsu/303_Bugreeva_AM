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
foreach ($groupQuery as $group) {
    $course = (int)ltrim($group['course'], '0') + 1;
    if ($course > 4) $course = 4;
    $fullGroupNumber = $course . '0' . $group['groupNumber'];
    $groupsId[$fullGroupNumber] = $group['id'];
}


$request = <<<QUERY
SELECT studentsNumber, surname, student.name, lastname, sex, birthDate, groupId,
educationalDirection.name as edName from student inner join `group` on groupId == `group`.id
                          inner join educationalDirection on educationalDirectionId == educationalDirection.id
QUERY;
$group = '';
if ($_POST['group']) {
    $group = $_POST['group'];
    $request .= " where groupId == {$groupsId[$group]}";
}
$request .= ' order by startDate desc, groupNumber, surname, student.name, lastname;';

$statement = $pdo->query($request);
$students = $statement->fetchAll();
$statement->closeCursor();
?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>StudentsMRSU</title>
</head>
<body>
<form method="POST" action="">
    <label>
    <select name="group">
    <option value=''>Все</option>
    <?php
    foreach (array_keys($groupsId) as $groupNum) {
        print<<<HTML
    <option value={$groupNum}>$groupNum</option>
HTML;
    }
    ?>
    </select>
    </label>
    <button type="submit">Выбрать группу</button>
</form>
	<table border="1px" cellpadding="3px">
		<tr>
		<th>Группа</th>
		<th>ФИО</th>
		<th>Пол</th>
		<th>Дата рождения</th>
		<th>Номер студенческого</th>
		<th>Направление</th>
		</tr>
		<?php
        foreach ($students as $student) {
            $groupVal = $group;
            if ($groupVal === "") {
                $groupVal = array_search($student['groupId'], $groupsId);
            };
            print <<<HTML
            <tr>
                <td>$groupVal</td>
                <td>{$student['surname']} {$student['name']} {$student['lastname']}</td>
                <td>{$student['sex']}</td>
                <td>{$student['birthDate']}</td>
                <td>{$student['studentsNumber']}</td>
                <td>{$student['edName']}</td>
            </tr>
HTML;
        }?>
	</table>
</body>
</html>
