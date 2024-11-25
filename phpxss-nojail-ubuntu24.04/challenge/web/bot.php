<?php
// You might want to use a database os something similar.
// For sake of simplicitly we use a file

function appendPathToFile($filename, $path) {
  $fp = fopen($filename, "a+");
  if(!$fp) return false;
  $timeout = 0;
  while(!flock($fp, LOCK_EX)) {
    if($timeout == 5) return false;
    $timeout++;
    fclose($fp);
    sleep(1);
  }

  fwrite($fp, $path . "\n");

  fflush($fp);
  flock($fp, LOCK_UN);
  fclose($fp);
  return true;
}

$path = $_POST["path"];
$reportStatus = appendPathToFile("/tmp/paths", $path);
?>
<html>
<body>
<?= $reportStatus ? "Thank you for your report. We will check it immediately" : "Could not report. Please contact an admin"; ?>
<fieldset>
<legend>GlacierReportBot</legend>
<form method="POST">
<input type="text" name="path" placeholder="/<path>" />
<button>Report</button>
</form>
</fieldset>
</body>
</html>

