require "rmcp/proto"

module RMCP
  module EM
    class Connection < ::EM::Connection
      PORT = 623

      attr_reader :addr, :port

      def initialize(addr, port = PORT)
        @addr = addr
        @port = port
      end

      def post_init
        $stderr.puts "sending ping to #{@addr}:#{@port}"
        send_datagram(Proto::Message.new(:ping).encode(1), @addr, @port)
      end

      def send_datagram(msg, addr, port)
        $stderr.puts "send #{addr}:#{port} - #{msg.inspect}"
        super(msg, addr, port)
      end

      def receive_data(packet)
        $stderr.puts "recv: #{packet.inspect}"
        msg = Proto.decode(packet)
        $stderr.puts "  header: #{msg.header.inspect}"
        $stderr.puts "  data: #{msg.data.inspect}"
        $stderr.puts "  body: #{msg.body.inspect}"
        $stderr.puts "  resp?: #{msg.resp?}"
        $stderr.puts "  type: #{msg.type}"
        $stderr.puts "  tag: #{msg.tag}"
        $stderr.puts "  len: #{msg.len}"
      end

      def peer
        Socket.unpack_sockaddr_in(get_peername).reverse
      end

    end # Connection:: < ::EM::Connection
  end # module::EM
end # module::RMCP
