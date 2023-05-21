<html>
	<head>
		<title>Активные выдачи</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="button.css">
	</head>
	<center><font size="6" color="white" face="Palatino Linotype">Библиотечная система<br></font></center>
	<br>
	<body >
	<?php
	session_start();
	?>		
		<?php 		 	
		$db=pg_connect("host=localhost dbname=Library user=postgres password=12345") or die("Соединение не установлено!");
		$result = pg_query($db, "SELECT * FROM see_activeborrows() AS (bname varchar(100), rname varchar(100), borrowdate date, returndate date);")or die(pg_last_error($db));	
		$a=pg_fetch_array($result);
		echo "<table class=table>";
		echo "<tr><th><b>Название книги</b></th><th><b>ФИО читателя</b></th><th><b>Дата выдачи</b></th><th><b>Дата возврата</b></th><tr>";
		do
		{
			$pole1=$a[0];
			$pole2=$a[1];
            $pole3=$a[2];
            $pole4=$a[3];
			echo "<tr><td>$pole1</td><td>$pole2</td><td>$pole3</td><td>$pole4</td><tr>";
		} while ($a=pg_fetch_array($result));
		echo "</table>";
		
		?>
		<br>
		<br>
		<a class="aa" href="glav.php">На главную</a>
	</body>


</html>