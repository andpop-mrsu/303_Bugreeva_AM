<?php
require_once '../utils.php';

if($_SERVER['REQUEST_METHOD'] === 'POST') {
    header('Location: index.php');

    $pdo = new PDO('sqlite:../data/students.db');
    $sql = "UPDATE student SET name=?, surname=?, lastname=?, sex=?, groupId=?, educationalDirectionId=?, birthDate=? WHERE studentsNumber=?";
    $statement = $pdo->prepare($sql);
    $statement->execute([$_POST['name'], $_POST['surname'], $_POST['lastname'], $_POST['sex'], $_POST['groupId'], $_POST['edId'], $_POST['birthDate'], $_POST['studentNumber']]);
    $statement->closeCursor();
    exit();
}
$groupsId = getGroupsId();

$studentNumber = $_GET['id'];
$studentMap = getStudentWithId($studentNumber);
$groups = getGroupsNumber();

print<<<HTML
<html>
<head>
<meta charset="UTF-8">
<title>UpdateStudent</title>
</head>
<body>
<h3>Введите новые данные</h3>
<form action="update.php" method="POST">
    <input type="hidden" name="studentNumber" value={$studentNumber}>
    Фамилия: <input type="text" name="surname" value={$studentMap['surname']}><br> 
    Имя: <input type="text" value={$studentMap['name']} name="name"><br>
    Отчество: <input type="text" value={$studentMap['lastname']} name="lastname"><br>
    Пол:
HTML;
if ($studentMap['sex'] === 'мужской') {
    print<<<HTML
    <input type="radio" value="мужской" name="sex" checked="checked">Мужской
    <input type="radio" value="женский" name="sex">Женский<br>
HTML;
} else {
    print<<<HTML
    <input type="radio" value="мужской" name="sex">Мужской
    <input type="radio" value="женский" name="sex" checked="checked">Женский<br>
HTML;
}

print<<<HTML
    Направление подготовки<br>
    <select name="edId">
HTML;
foreach (getEducationalDirections() as $education) {
    if ($education['name'] === $studentMap['edName']) print "<option value={$education['id']} selected=\"selected\">{$education['name']}</option>";
    else print "<option value={$education['id']}>{$education['name']}</option>";
}
print <<<HTML
    </select><br>
    Группа
    <select name="groupId">
HTML;

foreach (getGroupsNumber() as $id => $groupNum) {
    if ($id === $studentMap['groupId']) print "<option value={$id} selected='selected'>{$groupNum}</option>";
    else print "<option value={$id}>{$groupNum}</option>";
}

print<<<HTML
    <input type="date" name="birthDate" value={$studentMap['birthDate']}>
</select>
    <input type="submit" value="Изменить">
</form>
</body>
</html>
HTML;
