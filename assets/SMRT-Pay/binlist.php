<?php
$file = '/var/www/assets/SMRT-Pay/binlist-cached.json';
$data = json_decode(file_get_contents('php://input'), true);
if ($data && isset($data['bin'])) {
  $list = file_exists($file) ? json_decode(file_get_contents($file), true) : [];
  // Check not already present
  foreach ($list as $row) if ($row['bin'] == $data['bin']) exit('OK');
  $list[] = $data;
  file_put_contents($file, json_encode($list, JSON_PRETTY_PRINT));
  echo 'OK';
}
?>

