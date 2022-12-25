<?php
require_once '../utils.php';

$groupsId = getGroupsId();

$pdo = new PDO('sqlite:../data/students.db');

$request = <<<QUERY
SELECT studentsNumber, surname, student.name, lastname, sex, birthDate, groupId,
educationalDirection.name as edName from student inner join `group` on groupId == `group`.id
                          inner join educationalDirection on educationalDirectionId == educationalDirection.id
QUERY;
$group = '';
if ($_GET['group']) {
    $group = $_GET['group'];
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
<form method="GET" action="">
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
        <th></th>
        <th></th>
        <th></th>
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
                <td>
                    <form action="update.php" method="GET">
                        <input type="hidden" name="id" value={$student['studentsNumber']}>
                        <input type="submit" value="Изменить">

                    </form>
                </td>
                <td>
                    <form action="delete.php" method="GET">
                        <input type="hidden" name="id" value={$student['studentsNumber']}>
                        <input type="submit" value="Удалить">
                    </form>
                </td>
                <td>
                    <form action="marks.php" method="GET">
                        <input type="hidden" name="id" value={$student['studentsNumber']}>
                        <input type="submit" value="Оценки">
                    </form>
                </td>
            </tr>
HTML;
        }?>
	</table>
<br>
<form action="create.php">
    <input type="submit" value="Добавить">
</form>
</body>
</html>
