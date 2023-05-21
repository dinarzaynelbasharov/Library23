<html>
	<head>
		<title>Удаление книги</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="button.css">
	</head>
	<center><font size="6" color="White" face="Palatino Linotype">Библиотечная система<br></font></center>
	<br>
	<body >
	<?php
	session_start();
	?>
	<?php
        $s=pg_connect("host=localhost dbname=Library user=postgres password=12345") or die("Соединение не установлено!");
        $r=pg_query($s,"SELECT * FROM see_books() AS (id integer, bname varchar(100), releaseyear integer, tname varchar(100), aname varchar(100), pages integer, pname varchar(100), amount integer);")or die(pg_last_error($s));
        ?>
		<form action="<?php echo $_SERVER['PHP_SELF']; ?>" name="additem" method="GET"> 
		<select class="txtb" name="add_book" required value=""><option value="" disabled selected style='display:none;'>Название книги</option>
                                        <?php while($object = pg_fetch_array($r)): ?>
                                        <option value ="<?=$object[0]?>"><?=$object[1]?></option>
                                        <?php endwhile;?>
                                    </select> <br><br>
			<input class="btt" name="submit" type="submit" value="Удалить книгу">  
		</form>
		<?php 		
		if (isset($_GET['add_book'])){		
		$code = $_GET['add_book'];				
		$db_table = "books"; 	
		$db=pg_connect("host=localhost dbname=Library user=postgres password=12345") or die("Соединение не установлено!");	
		$result = pg_query($db, "SELECT delete_book('$code');");		 		
		if ($result = 'true'){
         echo "<div style=\"font:bold 24px Palatino Linotype; color:white;\">Книга удалена из базы!</div>";;
		}
		}
		?>
		<br>
		<a class="aa" href="glav.php">На главную</a>
	</body>


</html>