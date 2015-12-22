# This repeats commands as necessary to work around signal issues.

# Example:
# $bedroom_ac->tie_event('repeat_command($bedroom_ac)');
 
# this will get called every time a switch is toggled locally, or every
# time you run get_status or on receipt of remote activations
sub repeat_command
{
    my ($ref_device) = @_;
    # avoid unnecessary traffic, like a get_status where status hasn't changed.
    if ($ref_device->state_changed) {
        print_log "repeat_command.pl: repeat_command called for state_changed on ".
            $ref_device->get_object_name." to ".$ref_device->state.".";
        # delay is to avoid collisions. In case we're in this code path
        # due to a remote toggle instead (you pushed the switch), that switch
        # could already be running a scene and you don't want to conflict with it
        # (for local state changes, this is not an issue).
        $ref_device->set_with_timer('', 1, $ref_device->state);
    }
}
