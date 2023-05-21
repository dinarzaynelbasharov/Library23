<html>
<head>
	<title>Регистрация</title>
	<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
	<link rel="stylesheet" href="button.css">
</head>
<body >
<center><font size="6" color="white" face="Palatino Linotype">Библиотечная система</font></center>
<br><br><br><br><br><br>
<center><font size="5" color="White"><b>Регистрация:</b>
<form  class="kek" method="get"> 
<table><tr>
<td><font size="5" color="White"><label>Логин:</label></td>
<td><input class="txa" type="text" name = "login"  maxlength = "20"></td></tr><br>
<tr>
<td><font size="5" color="White"><label>Пароль:<label></td>
<td><input class="txa" type="password" name = "password"  maxlength = "20"></td></tr>
</table> <br>
<input class="btt" type="submit" name="Submit"  value="Зарегистрироваться">
</form>

<?php
if (isset($_GET['login']) && isset($_GET['password'])){
$login = $_GET['login'];
$password = $_GET['password'];
$table = "readers";
$db=pg_connect("host=localhost dbname=Library user=postgres password=12345") or die("Соединение не установлено!");		
$test = pg_query($db, "SELECT * FROM check_pass() AS (login varchar(20), password varchar(20));")or die(pg_last_error($db));
$count = false;
$a=pg_fetch_array($test);
do
		{
	$a2 = $a[0];
	if ($a2 == $login) {
		$count = true;
	}
		} while ($a=pg_fetch_array($test));
if ($count == true){
	echo "Данный логин занят";
}
else {
	pg_query($db,"SELECT add_pass('$login', '$password');") or die(pg_last_error($db));
	echo "<div style=\"font:bold 24px Palatino Linotype; color:white;\">Вы успешно зарегистрированы</div>";
}		
}
?>
<center><p><a class="aa" href="index.php">Вернуться на предыдущую страницу</a></p>

</body>
</html>