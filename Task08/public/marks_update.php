<?php

header("Location: marks.php?id={$_POST['id']}");

$markId = $_POST['mark_id'];
$mark = $_POST['mark'];

$pdo = new PDO('sqlite:../data/students.db');
$sql = 'update marks set mark=? where id=?';
$statement = $pdo->prepare($sql);
$statement->execute([$mark, $markId]);
$statement->closeCursor();
exit();

