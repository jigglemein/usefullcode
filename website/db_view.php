Click Refresh to add a new row

<?php
$servername = "db";
$username = "master";
$password = "testtest";
$dbname = "mydb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "INSERT INTO MyGuests (firstname, lastname, email)
VALUES ('John', 'Doe', 'john@example.com')";

if ($conn->query($sql) === TRUE) {
    echo "row created successfully";
} else {
    echo "Error creating roe: " . $conn->error;
}

$result = $conn->query("SELECT * FROM MyGuests");

echo "<table border='1'>
<tr>
<th>Firstname</th>
<th>Lastname</th>
</tr>";

while($row = mysqli_fetch_array($result))
{
echo "<tr>";
echo "<td>" . $row['firstname'] . "</td>";
echo "<td>" . $row['lastname'] . "</td>";
echo "</tr>";
}
echo "</table>";
$conn->close();


?>

