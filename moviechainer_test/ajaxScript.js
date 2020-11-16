function createMoviesTable() {
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        document.getElementById("moviesTable").innerHTML = this.responseText;
      }
    };
    xmlhttp.open("GET","index.php",true);
    xmlhttp.send();
}
createMoviesTable()