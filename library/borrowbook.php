<html>
	<head>
		<title>Взятие книги</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="button.css">
	</head>
	<center><font size="6" color="white" face="Palatino Linotype">Библиотечная система<br></font></center>
	<br>
	<body>
	
    <?php
	session_start();
	$login = $_SESSION['Name'];
        $s=pg_connect("host=localhost dbname=Library user=postgres password=12345") or die("Соединение не установлено!");
	$getnum = pg_query($s,"SELECT * FROM see_reader('$login') AS (id integer);")or die(pg_last_error($s));
	$getnum2=pg_fetch_array($getnum);
	$num = $getnum2[0];
        $r=pg_query($s,"SELECT * FROM see_availablebooks() AS (id integer, fullname text);")or die(pg_last_error($s));
        $r2=pg_query($s,"SELECT * FROM see_types() AS (id integer, name varchar(100));")or die(pg_last_error($s));
        $r3=pg_query($s,"SELECT * FROM see_publishers() AS (id integer, name varchar(100));")or die(pg_last_error($s));
        ?>
		<form action="<?php echo $_SERVER['PHP_SELF']; ?>" name="additem" method="GET"> 
            <select class="txtb" name="add_book" required value=""><option value="" disabled selected style='display:none;'>Название книги</option>
                                        <?php while($object = pg_fetch_array($r)): ?>
                                        <option value ="<?=$object[0]?>"><?=$object[1]?></option>
                                        <?php endwhile;?>
                                    </select> <br><br>
			<input class="btt" name="submit" type="submit" value="Взять книгу">  
		</form>
		<?php 		
		if (isset($_GET['add_book']))
		{		
		$b = $_GET['add_book'];
		$db_table = "borrows";		
		$result = pg_query($s, "SELECT add_borrow('$b', '$num');")or die(pg_last_error($s));	
        $res = pg_query($s, "SELECT * FROM see_returndate() AS (dayy double precision, monthh text, yearr double precision);")or die(pg_last_error($s));
        $rrrr=pg_fetch_array($res);
        $res1 = $rrrr[0];
        $res2 = $rrrr[1];
        $res3 = $rrrr[2];		
		if ($result = 'true'){
         echo "<div style=\"font:bold 24px Palatino Linotype; color:white;\">Книга взята! Её следует вернуть до $res1 $res2 $res3. Либо продлить срок сдачи.</div>";
		pg_query($s, "SELECT update_bookamountminus('$b');")or die(mysqli_error($s));
		}		
		}
		?>
		<br>
		<a class="aa" href="glav.php">На главную</a>
	
	</body>


</html>