# This makes the X10 fan come on and off without an X10 link from the controller.

$bedside_C->tie_event('do_fan($bedside_C)');
 
sub do_fan
{
    my ($button_used) = @_;
    print_log "do_fan: Setting to " . $button_used->state;

    # Do three times, because signal sucks.
    $fan->set($button_used->state);
    $fan->set($button_used->state);
    $fan->set($button_used->state);
}
