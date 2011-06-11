# This ties the lights on the Keypadlic to the appropriate devices.

$living_room->tie_event('sync_kpl_lights($living_room, $foyer_A_scene)'); # noloop
$bedroom->tie_event('sync_kpl_lights($bedroom, $foyer_B_scene)'); # noloop
$living_ac->tie_event('sync_kpl_lights($living_ac, $foyer_C_scene)'); # noloop
$bedroom_ac->tie_event('sync_kpl_lights($bedroom_ac, $foyer_D_scene)'); # noloop
 
# this will get called every time a switch is toggled locally, or every
# time you run get_status or on receipt of remote activations
sub sync_kpl_lights
{
    my ($ref_light, $kpl_scene) = @_;
    # avoid unnecessary traffic, like a get_status where status hasn't changed.
    if ($ref_light->state_changed) {
        print_log "MYLOGKPL: sync_kpl_lights called for state_changed on ".
            $ref_light->get_object_name." to ".$ref_light->state." for ".
            $kpl_scene->get_object_name." set kpls in 1sec";
        # delay is to avoid collisions. In case we're in this code path
        # due to a remote toggle instead (you pushed the switch), that switch
        # could already be running a scene and you don't want to conflict with it
        # (for local state changes, this is not an issue).
        $kpl_scene->set_with_timer('', 1, $ref_light->state);
    }
}
