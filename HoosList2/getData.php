<?php
	 $con=mysqli_connect("localhost", "root", "O,Mall3y", bag3cn);

	  // Check connection
	  if (mysqli_connect_errno())
	  {
	   echo "Failed to connect to MySQL: " . mysqli_connect_error();
	  }

	  $query = "SELECT * from tasks";

	  $result = mysqli_query($con,$query);

	  $rows = array();
	  while($r = mysqli_fetch_array($result)) {
	    $rows[] = $r;
	  }
	  echo json_encode($rows);

	  mysqli_close($con);
?>