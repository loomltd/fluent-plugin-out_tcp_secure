# Fluentd output plugin for loomsystems.com.
Link to the [loomsystems.com documentation](http://support.loomsystems.com/sources/connect-existing-log-management-tools/fluentd)

Fluentd output plugin for loomsystems contains a proper JSON formatter and a socket handler that streams logs directly to your loomsystems sub-domain.

## Pre-requirements

To add the plugin to your fluentd agent, use the following command:

    gem install fluent-plugin-loomsystems

## Usage
### Configure the output plugin

To match events and send them to loomsystems.com, simply add the following code to your fluentd configuration file.

```xml
<match **>
  @type loomsystems
  host <your-subdomain>.loomsystems.com
</match>
```
After a restart of Fluentd, all flunetd events will be sent to your loomsystems sub-domain.

Example of match (output) with event tag: 

```xml
<source>
  @type dummy
  dummy {"hello":"loomsystems"}        
  tag loomsystems 
</source>  

<match loomsystems.**>
  @type loomsystems
  host <your-subdomain>.loomsystems.com
</match>
```
After a restart of Fluentd, any child events tagged with loomsystems are shipped to your loomsystems sub-domain.

### fluent-plugin-loomsystems properties

As fluent-plugin-loomsystems is an output_buffer, you can set all output_buffer properties like it's describe in the [fluentd documentation](http://docs.fluentd.org/articles/output-plugin-overview#buffered-output-parameters "documentation").

Custom properties:

|  Property   |  Description                                                                             | Default value |
|-------------|------------------------------------------------------------------------------------------|---------------|
| **host**| The matched events tagged with "loomsystems.**" will be sent to your loomsystems sub-domain  |   *requierd   |
| **use_ssl** | If true, opens a secured TCP connection to loomsystems.com, and a non secured otherwise  |      true     |
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
### We are big funs of open source projects :) So please feel free to use, change, fix, and ask question. Good Luck from Loom Systems!
