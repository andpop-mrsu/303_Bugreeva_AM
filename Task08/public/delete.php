<?php
header('Location: index.php');

$pdo = new PDO('sqlite:../data/students.db');
$sql = "DELETE FROM student WHERE studentsNumber=?;";
$statement = $pdo->prepare($sql);
$statement->execute([$_GET['id']]);
$statement->closeCursor();
