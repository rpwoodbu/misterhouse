# This will send an e-mail if the state of a device is not a certain state.

# device - Device to check.
# state - State it should be in.
# email - E-mail address to alert if check fails.
sub email_if_not_state
{
    my ($device, $state, $email) = @_;
    my $devname = $device->{object_name};

    if ($device->state != $state) {
        print_log "email_if_not_state: $devname is not $state; emailing $email.";

        my $sendmail = "/usr/sbin/sendmail -t";
        my $reply_to = "Reply-to: nobody\@mybox.org\n";
        my $subject  = "Subject: Misterhouse: $devname not $state.\n";
        my $content  = "Device $devname is not in the expected state ($state).\n";
        my $send_to  = "To: $email\n";

        if (open(SENDMAIL, "|$sendmail")) {
            print SENDMAIL $reply_to;
            print SENDMAIL $subject;
            print SENDMAIL $send_to;
            print SENDMAIL "Content-type: text/plain\n\n";
            print SENDMAIL $content;
            close(SENDMAIL);
        } else {
            print_log "email_if_not_state: Cannot open $sendmail: $!";
        }
    } else {
        print_log "email_if_not_state: $devname is $state; all is well.";
    }
}
