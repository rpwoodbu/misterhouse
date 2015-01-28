# This sends a Wake-on-LAN to the MythTV server.

$remote_C->tie_event('do_mythtv($remote_C)');

sub do_mythtv
{
    my ($button_used) = @_;
    print_log "do_mythtv: Got a button press of " . $button_used->state;
    if ($button_used->state eq "on") {
        print_log "do_mythtv: Sending Wake-on-LAN to MythTV";
        system("/usr/bin/wakeonlan 1c:6f:65:93:35:fa");
        print_log "do_mythtv: Sending CEC to TV";
        my ($cmd) = "/bin/echo -ne \"p 0 1\\nas\\nq\\n\" | /usr/local/bin/cec-client";
        print_log $cmd;
        system($cmd);
    } else {
        print_log "do_mythtv: Sending CEC (standby) to TV";
        my ($cmd) = "/bin/echo 'standby 0' | /usr/local/bin/cec-client -s";
        print_log $cmd;
        system($cmd);
    }
}
