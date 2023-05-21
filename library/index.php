<html>
<head>
	<title>Авторизация</title>
	<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
	<link rel="stylesheet" href="button.css">
</head>
<body>
<div class="log">
<center><font size="6" color="White" face="Palatino Linotype">Библиотечная система</font></center>
<div class="loginform">
<center><font size="6" color="White"><b>Авторизация:</b>
<center><form class="kek" method = "post">
<table><tr><td>
<font size="5" color="White"><label>Логин:</label></td><td><input class="txa" type="text" name="log" /></td></tr>
<tr><td><font size="5" color="White"><label>Пароль:</label></td><td><input class="txa" type="password" name="passs" /></td></table>
<input class="aa" type="submit" name="pass"  value="Войти">
</form>

<?php
session_start();
If (isset ($_POST['log'])) 
{
$db = pg_connect("host=localhost dbname=Library user=postgres password=12345") or die("Соединение не установлено!");
$res = pg_query($db,"SELECT * FROM check_pass() AS (login varchar(20), password varchar(20));") or die(pg_last_error($db)); 
$array = pg_fetch_array($res); 
do
{
$x = True;
If ($_POST['log'] == $array['login'] && $_POST['passs'] == $array['password'] )  
	{ 
		$_SESSION['Name']=$_POST['log'];
		echo "<script language = 'javascript'>
		document.location.href = 'glav.php';
		</script>";
		$x=False;
	}
} while($array= pg_fetch_array($res));
If ($x = True) {echo "<div style=\"font:bold 24px Palatino Linotype; color:white;\">Неверный логин или пароль</div>";}
}
?>
<br>
<form align = "left" action = "reg.php" method = "post">
<center><input type="submit" class="aa" name="registration" value="Зарегистрироваться">
</form>
<a class="btt" href="glav.php">Войти как гость</a>

</div>
</div>

</body>
</html>