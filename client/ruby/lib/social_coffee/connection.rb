module SocialCoffee
    extend self

    def connect(host = '127.0.0.1', port = 9090, &block)
        client = Client.new host: host, port: port
        client.open

        if block_given? && block.arity == 1
            begin
                yield client
            ensure
                client.close
            end
        end
        client 
    end
end