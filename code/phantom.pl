# This will alert if there is a "phantom" change of a device state. This means
# that the device changed from one state to another without a device being held
# responsible for the state change. Misterhouse polls the state of all devices
# regularly, which is how this information is known.

# We only care about off and on. E.g., 60% is on.
sub munge_state
{
  my ($state) = @_;

  if ($state =~ /off/) {
    return "off";
  }
  return "on";
}

sub email_if_phantom_state
{
  my ($device, $email) = @_;
  my $devname = $device->{object_name};

  print_log "email_if_phantom_state: Checking $devname";
  my $last_state = "";
  my $last_log = "";
  my $bad_log = "";
  foreach my $log (reverse($device->state_log())) {
    my ($time, $value, $set_by) = (
      $log =~ /([\d\/]+ [\d:]+ [AP]M) (\S+) set_by=(.*)/
    );
    #print_log "phantom: last: $last_state  --  $last_log";
    #print_log "phantom: $device->{object_name} $time $value $set_by";
    if ($value eq "set_address_msb") {
      print_log "email_if_phantom_state: got set_address_msb, skipping";
      next;
    }
    if (not $set_by =~ /^\$PLM/) {
      $last_state = munge_state($value);
      $last_log = $log;
      $bad_log = "";
    } elsif ($last_state ne "" and $last_state ne munge_state($value)) {
      $bad_log = $log;
      print_log "email_if_phantom_state: $devname unexpectedly changed.";
      print_log "email_if_phantom_state: bad log: $bad_log";
      print_log "email_if_phantom_state: last log: $last_log";
    } else {
      $bad_log = "";
    }
  }

  if ($bad_log ne "") {
    print_log "email_if_phantom_state: Device $devname in bad state: $bad_log";

    my $sendmail = "/usr/sbin/sendmail -t";
    my $reply_to = "Reply-to: nobody\@mybox.org\n";
    my $subject  = "Subject: Misterhouse: $devname in phantom state.\n";
    my $content  = "Device $devname is " . $device->state . " for no apparent reason.\n";
    my $send_to  = "To: $email\n";

    if (open(SENDMAIL, "|$sendmail")) {
      print SENDMAIL $reply_to;
      print SENDMAIL $subject;
      print SENDMAIL $send_to;
      print SENDMAIL "Content-type: text/plain\n\n";
      print SENDMAIL $content;
      close(SENDMAIL);
    }
  }

  print_log "email_if_phantom_state: Done checking $device->{object_name}";
}
