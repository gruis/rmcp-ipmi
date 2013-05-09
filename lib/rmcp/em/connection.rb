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
        send_datagram(Proto::Message::Ping.new, @addr, @port)
      end

      def send_datagram(msg, addr, port)
        $stderr.puts "send #{addr}:#{port} - #{msg.inspect}"
        super(msg, addr, port)
      end

      def receive_data(packet)
        $stderr.puts "recv: #{packet.inspect}"
        msg = Proto.decode(packet)
        $stderr.puts "  type: #{msg.type} - #{Proto.type(msg.type)}"
        $stderr.puts "  ipmi: #{msg.ipmi?}"
        $stderr.puts "  asf: #{msg.asf?}"
        $stderr.puts "  ack: #{msg.ack?}"
        $stderr.puts "  resp?: #{msg.resp?}"

        case  msg
        when Proto::Message::Pong
          $stderr.puts "  support ipmi: #{msg.support_ipmi?}"
          $stderr.puts "  support asf_v1: #{msg.support_asf_v1?}"
          $stderr.puts "  support security extensions: #{msg.support_sec_ext?}"
          send_datagram(Proto::Message::Capabilities.request.seq!(2).tag!(2), @addr, @port)
          #send_datagram(Proto::Message.new(0x82).seq!(2).tag!(2), @addr, @port)
          ipmi_caps = ::IPMI::Message.new
          #send_datagram(Proto::Message.new(ipmi_caps).tag!(2), @addr, @port)
        else
          $stderr.puts "  header: #{msg.header.inspect}"
          $stderr.puts "  body: #{msg.body.inspect}"
          $stderr.puts "  type: #{msg.type}"
          $stderr.puts "  tag: #{msg.tag}"
          $stderr.puts "  len: #{msg.len}"
        end
      end

      def peer
        Socket.unpack_sockaddr_in(get_peername).reverse
      end

    end # Connection:: < ::EM::Connection
  end # module::EM
end # module::RMCP
