<?php
require_once '../utils.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    header('Location: index.php');

    $pdo = new PDO('sqlite:../data/students.db');
    $sql = "INSERT INTO student (studentsNumber, name, surname, lastname, sex, groupId, educationalDirectionId, birthDate)
VALUES (?, ?, ?, ?, ?, ?, ?, ?);";
    $statement = $pdo->prepare($sql);
    $statement->execute(
         [
            $_POST['studentsNumber'],
            $_POST['name'],
            $_POST['surname'],
            $_POST['lastname'],
            $_POST['sex'],
            $_POST['groupId'],
            $_POST['edId'],
            $_POST['birthDate']
         ]
    );
    $statement->closeCursor();
    exit();
}
?>
<html>
<head>
<meta charset="UTF-8">
<title>CreateStudent</title>
</head>
<body>
<h3>Введите новые данные</h3>
<form action="" method="POST">
    Номер студенческого: <input type="text" name="studentsNumber"><br>
    Фамилия: <input type="text" name="surname"><br> 
    Имя: <input type="text" name="name"><br>
    Отчество: <input type="text" name="lastname"><br>
    Пол:
    <input type="radio" value="мужской" name="sex" checked="checked">Мужской
    <input type="radio" value="женский" name="sex">Женский<br>
    Направление подготовки<br>
    <select name="edId">
<?php
foreach (getEducationalDirections() as $education) {
    print "<option value={$education['id']}>{$education['name']}</option>";
}
?>
    </select><br>
    Группа
    <select name="groupId">
<?php
foreach (getGroupsNumber() as $id => $groupNum) {
    print "<option value={$id}>{$groupNum}</option>";
}
?>
    <input type="date" name="birthDate">
</select>
    <input type="submit" value="Добавить">
</form>
</body>
</html>

