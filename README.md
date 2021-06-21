# Fluentd SSL/TLS secured TCP output plugin to generic receiver (ex: Logstash)
This plugin was initily developed as part of the loomsystems product for the use of our customers.
**There is no specific code for the loomsystem product and you can use it for any purpose**


Link to the [documentation](http://support.loomsystems.com/sources/connect-existing-log-management-tools/fluentd)

Link to a [StackOverflow question](https://stackoverflow.com/questions/46248762/fluentd-ssl-tls-secured-tcp-output-plugin-to-generic-receiver-logstash) that drove the creation of this plugin.

Fluentd output plugin for tcp secure contains a proper JSON formatter and a socket handler that streams logs directly to your chosen host.

## Requirements

To add the plugin to your fluentd agent, use the following command:

    gem install fluent-plugin-loomsystems

## Usage
### Configure the output plugin

To match *all* events and send them using this output plugin, add the following block to your fluentd configuration file:
```xml
<match **>
  @type loomsystems
  host <your-host>
</match>
```
Restart Fluentd to have the changes take effect.

Example of match (output) with event tag: 

```xml
<source>
  @type dummy
  dummy {"hello":"loom"}        
  tag loom 
</source>  

<match loom.**>
  @type loom
  host <your-subdomain>.loomsystems.com
</match>
```
Restart Fluentd to have events tagged with `loom` shipped to your domain.

### fluent-plugin-loomsystems properties

As fluent-plugin-loomsystems is an output_buffer, you can set all output_buffer properties like it's describe in the [fluentd documentation](https://docs.fluentd.org/configuration/buffer-section "documentation").

Custom properties:

|  Property   |  Description                                                                             | Default value |
|-------------|------------------------------------------------------------------------------------------|---------------|
| **host**| The matched events tagged with "loomsystems.**" will be sent to your loomsystems sub-domain  |   *requierd   |
| **use_ssl** | If true, opens a secured TCP connection to loomsystems.com, and a non secured otherwise  |      true     |
| **ssl_port** | If use_ssl is true, use this property for configuring the sending port                  |      9999     |
| **port** | If use_ssl is false, use this property for configuring the sending port                     |      8888     |
|**max_retries**| The number of retries before the output plugin stops. Set to -1 for unlimited retries  |       -1      |


### On the receiving Logstash side
***Do not use fluent codec! there is no need for that.***

Example of Logstash tcp input properties:

```xml
input {
    tcp {
        port => 9999
        ssl_enable => true
        ssl_cert => "creds/cert.pem"
        ssl_key => "creds/cert.key"
        ssl_verify => false
    }
}
```
### We are big funs of open source projects :) 
### So please feel free to use, change, fix, and ask questions. Good Luck!
