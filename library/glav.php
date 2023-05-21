<html>
	<head>
		<title>Главная</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="button.css">
	</head>
	<body>
	<center><font size="6" color="White" face="Palatino Linotype">Библиотечная система<br></font></center>
	<div class="leftleft">
	<a class="aa" href="books.php">Книги</a><br>
	<a class="aa" href="publishers.php">Издательские дома</a><br>
	<?php
	session_start();
	if(isset($_SESSION['Name'])){
		$login = $_SESSION['Name'];
	}
	$db=pg_connect("host=localhost dbname=Library user=postgres password=12345") or die("Соединение не установлено!");
	if(isset($_SESSION['Name'])){
		$result = pg_query($db, "SELECT * FROM check_reader('$login') AS (id integer, name varchar(100), phonenumber varchar(11), email varchar(100), dateofbirth date, login varchar(20), password varchar(20));")or die(pg_last_error($db));
		$result2 = pg_fetch_array($result);
	}
	if(isset($_SESSION['Name']))
	{
		if ($result2 && $_SESSION['Name'] != "admin") {
			echo '<div class="leftleft">
			<a class="aa" href="addreader.php">Добавить информацию</a>';
			}
	echo '<div class="leftleft">
	<a class="aa" href="borrowbook.php">Взять книгу</a>
	<a class="aa" href="dateexp.php">Продлить книгу</a>
	<a class="aa" href="bookback.php">Вернуть книгу</a>';
	if($_SESSION['Name'] == "admin")
	{
	echo '<div class="leftleft">
	<a class="aa" href="allactiveborrows.php">Активные выдачи</a>
	<a class="aa" href="allborrows.php">Все выдачи</a>
	<a class="aa" href="addauthor.php">Добавить автора</a>
	<a class="aa" href="addbook.php">Добавить книгу</a>
	<a class="aa" href="deletebook.php">Удалить книгу</a>
	<a class="aa" href="allreaders.php">Список всех читателей</a>
	</div>';
	};
	};
	?>
	<div><a class="down" href="logout.php">Выйти</a></div>	
	</body>


</html>