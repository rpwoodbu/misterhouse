# This sends a Wake-on-LAN to the MythTV server.

$remote_C->tie_event('do_mythtv($remote_C)');
 
sub do_mythtv
{
    my ($button_used) = @_;
    print_log "do_mythtv: Got a button press of " . $button_used->state;
    if ($button_used->state eq "on") {
        print_log "do_mythtv: Sending Wake-on-LAN to MythTV";
        system("/usr/bin/wakeonlan 00:04:61:9d:74:2c");
    }
}
