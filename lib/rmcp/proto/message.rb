module RMCP
  class Proto
    class Message
      FORMAT = "CCCCNCCCC"

      class << self
        def decode(packet)
          header, body = packet[0...12].unpack(FORMAT), packet[12..-1]
          header, data = header[0...4], header[4..-1]
          unless data[4] == body.length
            raise Error::ProtocolError.new("expected body length #{body.length} to equal #{data[4].inspect}")
          end

          allocate.tap do |m|
            m.instance_variable_set(:@header, header)
            m.instance_variable_set(:@data, data)
            m.instance_variable_set(:@body, body)
          end
        end
      end

      attr_reader :header, :data, :body


      def initialize(type, body = "")
        @data   = [4542, 0x80, 0, 0] # defaults to a ping request
        @header = []
        self.type = type
        self.body = body
      end

      def encode(tag)
        # TODO support ack messages: 7th bit of 4th element (class of message) should be 1
        # TODO determine IANA enterprise number from message type
        [Proto::VERSION, 0, 0, 6, data[0], data[1], tag, data[3], data[4]].pack(FORMAT) + (@body)
      end


      def type
        Proto::TYPE[@data[1]]
      end

      def type=(sym)
        raise ArgumentError.new("unrecognized type: #{sym.inspect}") unless (t = Proto::TYPE.index(sym))
        @data[1] = t
      end

      def body=(b)
        @body    = b || ""
        @data[4] = @body.length
      end

      def tag
        @data[2]
      end

      def len
        @data[4]
      end

      def resp?
        @data[1] >= 0x40 && @data[1] <= 0x7f
      end

      def req?
        (@data[1] >= 0x10 && @data[1] <= 0x3f) || (@data[1] >= 0x80 && @data[1] <= 0xbf)
      end

      def get?
        @data[1] >= 0x80 && @data[1] <= 0xbf
      end

      def set?
        @data[1] >= 0x10 && @data[1] <= 0x3f
      end

    end # class::Message
  end # class::Proto
end # module::RMCP

require "rmcp/proto/message/pong"
