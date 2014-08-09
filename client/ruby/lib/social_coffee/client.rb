$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "gen-rb"))
Dir[File.join(File.dirname(__FILE__), "gen-rb/*.rb")].each { |path| require path }

module SocialCoffee
    class StdOutLogger
        %w(fatal error warn info debug).each do |level|
            define_method level.to_sym do |message|
                STDOUT.puts "#{level}: #{message}"
            end
        end
    end

    class Client
        attr_reader :client, :host, :port, :logger, :remote_address

        def initialize(host: '127.0.0.1', port: 9090, timeout: 5, logger: StdOutLogger.new)
            @host, @port, @logger = host, port, logger 

            @remote_address = "#{@host}:#{@port}"

            @transport          = ::Thrift::Socket.new host, port, timeout
            @framed_transport   = ::Thrift::FramedTransport.new @transport
            @protocol           = ::Thrift::BinaryProtocol.new @framed_transport

            info "SocialCoffee::Client about to connect to #{@remote_address} ..."

            @client = Thrift::SocialCoffeeService::Client.new @protocol 
        end

        def open
            @framed_transport.open

            info "SocialCoffee::Client connected to remote host at #{@remote_address}"
        end

        def close
            @framed_transport.close

            info "SocialCoffee::Client disconnected from remote host at #{@remote_address}"
        end

        def method_missing(method, *args)
            @client.send method, *args
        end

        %w(fatal error warn info debug).each do |level|
            define_method level.to_sym do |message|
                @logger.send level, message if @logger and @logger.respond_to?(level.to_sym)
            end
        end
    end
end