<html>
	<head>
		<title>Книги</title>
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
		$result = pg_query($db, "SELECT * FROM see_books() AS (id integer, bname varchar(100), releaseyear integer, tname varchar(100), aname varchar(100), pages integer, pname varchar(100), amount integer);")or die(pg_last_error($db));	
		$a=pg_fetch_array($result);
		echo "<table class=table>";
		echo "<tr><th><b>№</b></th><th><b>Название книги</b></th><th><b>Год издания</b></th><th><b>Вид литературы</b></th><th><b>Автор</b></th><th><b>Кол-во страниц</b></th><th><b>Издатель</b></th><th><b>Наличие (шт.)</b></th><tr>";
		do
		{
			$pole1=$a[0];
			$pole2=$a[1];
            $pole3=$a[2];
            $pole4=$a[3];
            $pole5=$a[4];
            $pole6=$a[5];
            $pole7=$a[6];
		$pole8=$a[7];
			echo "<tr><td>$pole1</td><td>$pole2</td><td>$pole3</td><td>$pole4</td><td>$pole5</td><td>$pole6</td><td>$pole7</td><td>$pole8</td><tr>";
		} while ($a=pg_fetch_array($result));
		echo "</table>";
		
		?>
		<br>
		<br>
		<a class="aa" href="glav.php">На главную</a>
	</body>


</html>