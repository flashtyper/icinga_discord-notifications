# icinga_discord-notifications
send your notifications via webhook to your discord! 

## Output: 
![grafik](https://user-images.githubusercontent.com/83031404/116736430-2bfa4800-a9f0-11eb-80e0-257aaa8b5b74.png)
![grafik](https://user-images.githubusercontent.com/83031404/116736514-459b8f80-a9f0-11eb-93fd-c0ba4e8c091c.png)

## Installation:
1. Move file "discord-notification.pl" to /etc/icinga2/scripts
2. Move files "notification-command.conf" and "notification-template.conf" to your icinga2 configuration folder (e.g. /etc/icinga/conf.d)
3. apply notifications to your host or service
4. restart icinga2

## Troubleshooting
at first you should check your icinga config by ```icinga2 daemon -C```. if everything is alright then you have to go deeper... enable debug logging with ```icinga2 feature enable debuglog```. After that check your log with ```tail -f /var/log/icinga2/debug.log``` and send a custom notification to see what´s going on. 
