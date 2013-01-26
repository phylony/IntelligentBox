IntelligentBox
==============

The Net Relay Controller Model For IOS

create Socket;

sock=[[IntelligentSocket alloc] initWithType:udp withAddress:@"192.168.1.80"];

[sock SendCommand:@"1:1"];//first '1' mean stat, end '1' mean the relay sock;

you can update the files to shared doc;

that's all;
