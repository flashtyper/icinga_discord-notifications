#!/usr/bin/perl

use strict;
use warnings;
use JSON::XS;
#use Data::Dumper;
use REST::Client;

my %icinga_data = @ARGV;
my $rest = REST::Client->new(timeout => 5);
$rest->addHeader('Content-Type', 'application/json');

my $emoji_dict = {
  'OK' => ':white_check_mark:',
  'RECOVERY' => ':white_check_mark:',
  'WARNING' => ':warning:',
  'DOWN' => ':rotating_light:',
  'PROBLEM' => ':rotating_light:',
  'CRITICAL' => ':rotating_light:',
  'UNKNOWN' => ':grey_question:',
  'DOWNTIMESTART' => ':construction:',
  'DOWNTIMEEND' => ':construction:',
  'CUSTOM' => ':paintbrush:'
};

if ($icinga_data{notification_type} eq "CUSTOM") {
  custom();
} else {
  host_or_service();
}

sub custom {
  my $emote = $emoji_dict->{$icinga_data{notification_type}};
  my $notification = "$emote "
  . "$icinga_data{notification_type}: "
  . "Service **$icinga_data{service_name}** on host **$icinga_data{host_name}** "
  . "is in state **$icinga_data{service_state}**!\n"
  . "```$icinga_data{notification_author}: $icinga_data{notification_comment}\n\n"
  . "$icinga_data{service_output}```";
  send_msg($notification);
}

sub host_or_service {
  my $notification = "";
  if (defined($icinga_data{service_name})) {
    my $emote = $emoji_dict->{$icinga_data{service_state}};
    $notification = "$emote "
    . "$icinga_data{notification_type}: "
    . "Service **$icinga_data{service_name}** on host **$icinga_data{host_name}** "
    . "changed to **$icinga_data{service_state}**!\n"
    . "```$icinga_data{service_output}```";
  } else {
    my $emote = $emoji_dict->{$icinga_data{host_state}};
    $notification = "$emote "
    . "$icinga_data{notification_type}: "
    . "Host **$icinga_data{host_name}** "
    . "changed to **$icinga_data{host_state}**!\n"
    . "```$icinga_data{host_output}```";
  }
  send_msg($notification);
}

sub send_msg {
  my $notification = shift;
  my $payload = {
    username => $icinga_data{webhook_username},
    content => $notification
  };
  my $json = encode_json($payload);
  $rest->POST($icinga_data{webhook_url}, $json);
}
