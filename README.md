# pub_sub
A simple pub sub implementation using Thrift and Ruby

Create a broker using broker.rb.
Port defaults to 9090 but can take in another as argument.

Create a consumer listener using listener.rb.
Port defaults to 9091 but can take in another as argument.

Use consumer.rb to subscribe, unsubscribe, and publish.
First command line arg is the broker host, second is the port (default to localhost, 9090).
Following command line args are files to read instructions from.
Can also enter them through stdin.

Instruction format is csv with newline between instructions

sub, topic, host, port

unsub, topic, host, port

pub, topic, message

Here host and port are the host and port of the listener, so that the messages may be received
