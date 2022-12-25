<?php
require_once '../utils.php';

$pdo = new PDO('sqlite:../data/students.db');
$id = 0;
if($_SERVER['REQUEST_METHOD'] === 'POST') {
    if ((int)$_POST['mark'] >= 3 && (int)$_POST['mark'] <= 5) {
        $mark = (int)$_POST['mark'];
        $sql = "INSERT INTO marks (mark, studentId, disciplineId) VALUES (?, ?, ?);";
        $statement = $pdo->prepare($sql);
        $statement->execute(
            [
                $mark,
                $_POST['id'],
                $_POST['disciplineId']
            ]
        );
        $statement->closeCursor();
    }
    $id = $_POST['id'];
} else {
    $id = $_GET['id'];
}
$student = getStudentWithId($id);

$sql = "SELECT mark, discipline.name as subject, marks.id as mark_id  FROM marks INNER JOIN discipline ON disciplineId=discipline.id WHERE studentId={$id}";
$statement = $pdo->query($sql);
$marks = $statement->fetchAll();
$statement->closeCursor();



?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>StudentMarks</title>
</head>
    <table border="1px">
        <tr>
            <th>Предмет</th>
            <th>Оценка</th>
            <th>Удаление</th>
            <th>Изменение</th>
        </tr>
<?php
print "<h3> {$student['surname']} {$student['name']} {$student['lastname']}</h3>";
$subjects = [];
foreach ($marks as $mark) {
?>
            <tr>
               <td><?=$mark['subject']?></td>
               <td><?=$mark['mark']?></td>
               <td>
                    <form action="marks_delete.php" method="POST">
                        <input type="hidden" name="id" value=<?=$id?>>
                        <input type="hidden" name="mark_id" value=<?=$mark['mark_id']?>>
                        <input type="submit" value="Удалить">
                    </form>
               </td>
               <td>
                <form action="marks_update.php" method="POST">
                    <input type="hidden" name="id" value=<?=$id?>>
                    <input type="hidden" name="mark_id" value=<?=$mark['mark_id']?>>
                    <select name="mark">
                    <?php
                    for ($i = 3; $i<= 5; $i++) {
                        if($i != $mark['mark'])
                            print "<option value={$i}>{$i}</option>";
                    }
                    ?>
                    </select>
                    <input type="submit" value="Изменить">
                </form>
               </td>
            </tr>
<?php
    $subjects[] = $mark['subject'];
}
?>

</table>
<?php
    $sql = "SELECT discipline.name as subj_name, discipline.id as subj_id from discipline 
                    inner join plan on plan.disciplineId=discipline.id 
                    inner join student on student.educationalDirectionId=planId
                    where studentsNumber={$id};";
    $statement = $pdo->query($sql);
    $disciplines = $statement->fetchAll();
    $statement->closeCursor();

    if (count($disciplines) !== count($subjects)) {
    print <<<HTML
    <b>Поставить оценку(от 3 до 5):</b> <form action="" method="POST">
        <input type="hidden" name="id" value={$id}>
        <br><select name="disciplineId">
HTML;
     foreach ($disciplines as $discipline) {
         if (!in_array($discipline['subj_name'], $subjects))
             print "<option value={$discipline['subj_id']}>{$discipline['subj_name']}</option>";
     }

     print <<<HTML
        </select>
        <input type="text" name="mark" width="5px"><br>
        <input type="submit" value="Поставить">
    </form>
HTML;

    }
?>
<a href="index.php">Назад</a>
</body>
</html>
