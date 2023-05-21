<html>
	<head>
		<title>Добавление автора</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="button.css">
	</head>
	<center><font size="6" color="white" face="Palatino Linotype">Библиотечная система<br></font></center>
	<br>
	<body>
	<?php
	session_start();
	?>
		<form action="<?php echo $_SERVER['PHP_SELF']; ?>" name="additem" method="GET"> 
			<input class="txtb" type="text" name="add_author" placeholder="ФИО автора" required value=""> <br><br>
			<input class="btt" name="submit" type="submit" value="Добавить автора">  
		</form>
		<?php 		
		if (isset($_GET['add_author']))
		{		
		$a = $_GET['add_author'];
        	$db_table = "authors";
		$db=pg_connect("host=localhost dbname=Library user=postgres password=12345") or die("Соединение не установлено!");		
		$result = pg_query($db, "SELECT add_author('$a');")or die(pg_last_error($db));		 		
		if ($result = 'true'){
         echo "<div style=\"font:bold 24px Palatino Linotype; color:white;\">Автор добавлен!</div>";
		}		
		}
		?>
		<br>
		<a class="aa" href="glav.php">На главную</a>
	
	</body>


</html>