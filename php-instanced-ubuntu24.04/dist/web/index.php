<html>
  <body>
    Instance: <?= gethostname(); ?><br />
    <?php
      if(isset($_GET["flag"])) echo file_get_contents("/flag.txt");
    ?>
  </body>
</html>
