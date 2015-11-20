# pub_sub
simple pub sub implementation using Thrift and Ruby

create a broker using broker.rb
port defaults to 9090 but can take in another as argument

create a consumer listener using listener.rb
port defaults to 9091 but can take in another as argument

use consumer.rb to subscribe, unsubscribe, and publish
first command line arg is the host, second is the port (default to localhost, 9090)
following command line args are files to read instructions from
can also enter them through stdin

instruction format csv, newline between instructions
sub, topic, host, port
unsub, topic, host, port
pub, topic, host, port
