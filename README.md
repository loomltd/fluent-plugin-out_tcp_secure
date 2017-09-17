# FluentD output plugin for loomsystems.com.
Link to the [loomsystems.com documentation](http://support.loomsystems.com/sources/connect-existing-log-management-tools/fluentd)


It mainly contains a proper JSON formatter and a socket handler that
streams logs directly to loomsystems.com - so no need to use a log shipper
if you don't wan't to.

## Pre-requirements

To add the plugin to your fluentd agent, use the following command:

    gem install fluent-plugin-loomsystems

## Usage
### Configure the output plugin

To match events and send them to loomsystems.com, simply add the following code to your configuration file.

TCP example
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

After a restart of FluentD, any child events tagged with `loomsystems` are shipped to your plateform.

### fluent-plugin-loomsystems properties

As fluent-plugin-loomsystems is an output_buffer, you can set all output_buffer properties like it's describe in the [fluentd documentation](http://docs.fluentd.org/articles/output-plugin-overview#buffered-output-parameters "documentation").

Addisinal custom properties:

|  Property   |  Description                                                                             | Default value |
|-------------|------------------------------------------------------------------------------------------|---------------|
| **host**| The matched events tagged with "loomsystems.**" will be sent to your host at loomsystems.com |   *requierd   |
| **use_ssl** | If true, opens a secured TCP connection to loomsystems.com, and non secured otherwise.   |      true     |
|**max_retries**| The number of retries before the output plugin stops. Set to -1 for unlimited retries  |       -1      |
