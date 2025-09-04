#!/usr/bin/php
<?php
    require "../html/config/config.php";
    //require "../backup_2025-09-03/config/config.php";
    echo "export DBTYPE=" . $CONFIG['dbtype'] . "\n";
    echo "export DBNAME=" . $CONFIG['dbname'] . "\n";
    echo "export DBHOST=" . $CONFIG['dbhost'] . "\n";
    echo "export DBPORT=" . $CONFIG['dbport'] . "\n";
    echo "export DBUSER=" . $CONFIG['dbuser'] . "\n";
    echo "export DBPASSWORD=" . $CONFIG['dbpassword'] . "\n";
    $read_only_text = "true";
    if(!$CONFIG['config_is_read_only']) {
        $read_only_text = "false";
    }
    echo "export CONFIG_IS_READ_ONLY=$read_only_text\n";
?>

