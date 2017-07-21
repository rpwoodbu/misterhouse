# This will change the state of a device conditionally, dependent on whether
# there has been any Insteon activity in recent hours.
# One use case is not wanting to turn on the AC if
# no one is home, and Insteon activity is a good indicator
# of that.

# The devices to check for activity.
my @devices = (
  $living_room,
  $bedroom,
  #$lavalamp
);

# set_device - The device to set.
# setting - The setting for the device.
# time_limit - The number of seconds that there should be no activity.
sub conditional
{
  my ($set_device, $setting, $time_limit) = @_;
  my $duration = -1;

  foreach my $device (@devices) {
    foreach my $state ($device->state_log()) {
      my ($time, $value, $set_by) = (
        $state =~ /([\d\/]+ [\d:]+ [AP]M) (\S+) set_by=(.*)/
      );

      if (not $set_by =~ /^\$PLM/ and not $set_by =~ /^web/) {
        my $dev_duration = time() - str2time($time);
        if ($dev_duration < $duration or $duration == -1) {
          $duration = $dev_duration;
        }
        last;
      }
    }
  }

  if ($duration == -1) {
    print_log "conditional: We don't know when it was last manipulated.";
  } elsif ($duration <= $time_limit) {
    print_log "conditional: Last manipulated $duration seconds ago; taking action.";
    $set_device->set($setting);
  } else {
    print_log "conditional: Last manipulated $duration seconds ago; no action.";
  }
}
