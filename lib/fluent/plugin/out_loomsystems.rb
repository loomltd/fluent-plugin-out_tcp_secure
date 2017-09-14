require 'socket'
require 'openssl'
require 'yajl'

class Fluent::LoomsystemsOutput < Fluent::BufferedOutput
  class ConnectionFailure < StandardError; end

  # Register the plugin
  Fluent::Plugin.register_output('loomsystems', self)
  # Output settings
  config_param :use_json,       :bool,    :default => true
  config_param :include_tag_key,:bool,    :default => false
  config_param :tag_key,        :string,  :default => 'tag'

  # Connection settings
  config_param :host,           :string
  config_param :use_ssl,        :bool,    :default => true
  config_param :port,           :integer, :default => 8888
  config_param :ssl_port,       :integer, :default => 9999
  config_param :max_retries,    :integer, :default => -1

  def initialize
    super
  end

  # Define `log` method for v0.10.42 or earlier
  unless method_defined?(:log)
    define_method("log") { $log }
  end

  def configure(conf)
    super
  end

  def start
    log.info "----start"
    super
  end

  def shutdown
    log.info "----shutdown"
    super
  end

  def client
   @_socket ||= if @use_ssl
      log.info "opening ssl socket"
      context    = OpenSSL::SSL::SSLContext.new
      socket     = TCPSocket.new @host, @ssl_port
      ssl_client = OpenSSL::SSL::SSLSocket.new socket, context
      sock = ssl_client.connect
    else
      TCPSocket.new @host, @port
    end

    @_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, true)
    @_socket.setsockopt(Socket::SOL_TCP, Socket::TCP_KEEPIDLE, 10)
    @_socket.setsockopt(Socket::SOL_TCP, Socket::TCP_KEEPINTVL, 3)
    @_socket.setsockopt(Socket::SOL_TCP, Socket::TCP_KEEPCNT, 3)

    return @_socket

  end

  # This method is called when an event reaches Fluentd.
  def format(tag, time, record)
    #log.info "[tag, time, record] = #{tag}, #{time}, #{record}}"
    return [tag, {"timestamp"=>time, "host"=>@host, "message"=>record}].to_msgpack
  end

  # NOTE! This method is called by internal thread, not Fluentd's main thread.
  # 'chunk' is a buffer chunk that includes multiple formatted events.
  def write(chunk) 
    messages = Array.new
    chunk.msgpack_each do |tag, record|
      next unless record.is_a? Hash
      next unless record.has_key? "message"

      if @include_tag_key
        record[@tag_key] = tag
      end
      if @use_json
        messages.push Yajl.dump(record) + "\n"
      else
        messages.push record["message"].rstrip() + "\n"
      end
    end
    send_to_loomsystems(messages)

  end

  def send_to_loomsystems(data)   
    retries = 0

    begin

      # Check the connectivity and write messages
      #connected,x = client.recv(0)
      #log.trace  "Connected=#{connected},#{x}"
      #raise Errno::ECONNREFUSED, "Client has lost server connection" if connected == 0
      log.trace "New attempt to loomsystems attempt=#{retries}" if retries > 0
      log.trace "Send nb_event=#{data.size} events to loomsystems"
      data.each do |event|
        client.write(event)
      end


    # Handle some failures
    rescue Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EPIPE => e

      if retries < @max_retries || max_retries == -1
        @_socket = nil
        a_couple_of_seconds = retries ** 2
        a_couple_of_seconds = 30 unless a_couple_of_seconds < 30
        retries += 1
        log.warn "Could not push logs to loomsystems, attempt=#{retries} max_attempts=#{max_retries} wait=#{a_couple_of_seconds}s error=#{e.message}"
        sleep a_couple_of_seconds
        retry
      end
      raise ConnectionFailure, "Could not push logs to loomsystems after #{retries} retries, #{e.message}"
    end
  end

end