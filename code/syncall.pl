my $v_state;
$v_rescan = new Voice_Cmd 'AllDevices [Scan,Status]';

# Change 'PLM' with the name of your plm device in insteon.mht
if ($v_state = said $v_rescan)
{
  # from Insteon_PLM::poll_all
  foreach my $insteon_device ($PLM->find_members('Insteon_Device'))
  {
    if ($insteon_device and $insteon_device->is_root and $insteon_device->is_responder)
    {
      my ($dev_state, $dev_name) = ($insteon_device->state, $insteon_device->get_object_name);

      if ($v_state eq 'Scan')
      {
        print_log "log=logs/dev_status.log rescanning $dev_name that was $dev_state";
        $insteon_device->request_status();
      }
      # You can't call state right after status as the status commands are stacked up, so you have to ask later
      elsif ($v_state eq 'Status')
      {
        print_log "log=logs/dev_status.log status $dev_name is $dev_state";
      }
    }
  }
}
