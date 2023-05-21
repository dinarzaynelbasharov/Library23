<html>
	<head>
		<title>Добавление книги</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="button.css">
	</head>
	<center><font size="6" color="white" face="Palatino Linotype">Библиотечная система<br></font></center>
	<br>
	<body>
	<?php
	session_start();
	?>
    <?php
        $s=pg_connect("host=localhost dbname=Library user=postgres password=12345") or die("Соединение не установлено!");
        $r=pg_query($s,"SELECT * FROM see_authors() AS (id integer, name varchar(100));")or die(pg_last_error($s));
        $r2=pg_query($s,"SELECT * FROM see_types() AS (id integer, name varchar(100));")or die(pg_last_error($s));
        $r3=pg_query($s,"SELECT * FROM see_publishers() AS (id integer, name varchar(100));")or die(pg_last_error($s));
        ?>
		<form action="<?php echo $_SERVER['PHP_SELF']; ?>" name="additem" method="GET"> 
			<input class="txtb" type="text" name="add_bookname" placeholder="Имя книги" required value=""> <br><br>
            <select class="txtb" name="add_author" required value=""><option value="" disabled selected style='display:none;'>Имя автора</option>
                                        <?php while($object = pg_fetch_array($r)): ?>
                                        <option value ="<?=$object[0]?>"><?=$object[1]?></option>
                                        <?php endwhile;?>
                                    </select> <br><br>
            <input class="txtb" type="text" name="add_year" placeholder="Год издания" required value=""> <br><br>
            <input class="txtb" type="text" name="add_pages" placeholder="Количество страниц" required value=""> <br><br>
            <select class="txtb" name="add_type" required value=""><option value="" disabled selected style='display:none;'>Вид литературы</option>
                                        <?php while($object2 = pg_fetch_array($r2)): ?>
                                        <option value ="<?=$object2[0]?>"><?=$object2[1]?></option>
                                        <?php endwhile;?>
                                    </select> <br><br>
            <select class="txtb" name="add_publisher" required value=""><option value="" disabled selected style='display:none;'>Издатель</option>
                                        <?php while($object3 = pg_fetch_array($r3)): ?>
                                        <option value ="<?=$object3[0]?>"><?=$object3[1]?></option>
                                        <?php endwhile;?>
                                    </select> <br><br>
	    <input class="txtb" type="text" name="add_amount" placeholder="Количество" required value=""> <br><br>
			<input class="btt" name="submit" type="submit" value="Добавить книгу">  
		</form>
		<?php 		
		if (isset($_GET['add_bookname']) && isset($_GET['add_author']) && isset($_GET['add_year']) && isset($_GET['add_type']) && isset($_GET['add_pages']) && isset($_GET['add_publisher']) && isset($_GET['add_amount']))
		{		
		$a = $_GET['add_bookname'];
		$b = $_GET['add_author'];
        $c = $_GET['add_year'];
        $d = $_GET['add_type'];
        $e = $_GET['add_pages'];		
        $f = $_GET['add_publisher'];
	$g = $_GET['add_amount'];
		$db_table = "books";
		$check = pg_send_query($s, "SELECT add_book('$a','$c','$e','$b','$d','$f', '$g');");
		if ($check) {
			$error = pg_get_result($s);
			$error1 = pg_result_error($error);
			$error2 = mb_substr($error1, 0, 34);
			echo "<div style=\"font:bold 20px Palatino Linotype; color:white;\">$error2</div>";
		}			 			
		}
		?>
		<br>
		<a class="aa" href="glav.php">На главную</a>
	
	</body>


</html>