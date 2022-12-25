<?php

header("Location: marks.php?id={$_POST['id']}");
$mark_id = $_POST['mark_id'];

$pdo = new PDO('sqlite:../data/students.db');
$sql = 'delete from marks where id=?;';
$statement = $pdo->prepare($sql);
$statement->execute([$mark_id]);
exit();