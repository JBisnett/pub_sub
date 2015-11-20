# pub_sub
A simple pub sub implementation using Thrift and Ruby

Create a broker using

>broker.rb broker_port

Port defaults to 9090 but can take in another as argument.

Create a consumer using the command

>listener.rb listen_port listen_host broker_port broker_host

Type in

>subscribe topic

>unsubcribe topic

>publish topic message

To perform the operations for a topic or message.

EOF (ctrl-D) to stop listening.
