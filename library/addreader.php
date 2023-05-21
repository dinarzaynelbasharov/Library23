<html>
	<head>
		<title>Добавление информации о читателе</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="button.css">
	</head>
	<center><font size="6" color="white" face="Palatino Linotype">Библиотечная система<br></font></center>
	<br>
	<body>
	<?php
	session_start();
	$login = $_SESSION['Name'];
	?>
		<form action="<?php echo $_SERVER['PHP_SELF']; ?>" name="additem" method="GET"> 
			<input class="txtb" type="text" name="add_name" placeholder="ФИО читателя" required value=""> <br><br>
            <input class="txtb" type="text" name="add_phone" placeholder="Номер телефона (вместе с 8)" required value=""> <br><br>
            <input class="txtb" type="text" name="add_mail" placeholder="Электронная почта" required value=""> <br><br>
            <input class="txtb" type="date" name="add_birth" placeholder="Дата рождения" required value=""> <br><br>
			<input class="btt" name="submit" type="submit" value="Добавить читателя">  
		</form>
		<?php 		
		if (isset($_GET['add_name']) && isset($_GET['add_phone']) && isset($_GET['add_mail']) && isset($_GET['add_birth']))
		{		
		$a = $_GET['add_name'];
        $b = $_GET['add_phone'];
        $c = $_GET['add_mail'];
        $d = $_GET['add_birth'];
        $db_table = "readers";		
		$db=pg_connect("host=localhost dbname=Library user=postgres password=12345") or die("Соединение не установлено!");

		$check = pg_send_query($db, "SELECT update_reader('$a', '$b', '$c', '$d', '$login');");
		$error2 = "hello";

		if ($check) {
			$error = pg_get_result($db);
			$error1 = pg_result_error($error);
			$error2 = mb_substr($error1, 0, 48);
			echo "<div style=\"font:bold 20px Palatino Linotype; color:white;\">$error2</div>";
		}
		if ($error2 == "hello") {
			echo "<div style=\"font:bold 20px Palatino Linotype; color:white;\">Информация успешно добавлена!</div>";
		}
		}
		?>
		<br>
		<a class="aa" href="glav.php">На главную</a>
	
	</body>

</html>