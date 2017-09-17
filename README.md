# Fluentd output plugin for loomsystems.com.
Link to the [loomsystems.com documentation](http://support.loomsystems.com/sources/connect-existing-log-management-tools/fluentd)

Fluentd output plugin for loomsystems contains a proper JSON formatter and a socket handler that streams logs directly to your loomsystems sub-domain.

## Pre-requirements

To add the plugin to your fluentd agent, use the following command:

    gem install fluent-plugin-loomsystems

## Usage
### Configure the output plugin

To match events and send them to loomsystems.com, simply add the following code to your fluentd configuration file.

match (output) plugin example

```xml
 
####
## Output descriptions:
## the out_loomsystems output plugin enabling the transfer
## of fluentd events trough a secured ssl tcp connection.
## Configuration: match events tagged with "loomsystems.**" and
## send them to loomsystems.com
##

<match loomsystems.**>
  @type loomsystems
  host <your_loomsystems_platorm_address>
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
