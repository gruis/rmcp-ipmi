module RMCP
  class Proto
    class Message
      FORMAT = "CCCCNCCCC"

      class << self
        def decode(packet)
          header, body = packet[0...12].unpack(FORMAT), packet[12..-1]
          header, data = header[0...4], header[4..-1]
          unless data[4] == body.length
            warn Error::ProtocolError.new("expected body length #{body.length} to equal #{data[4].inspect}")
          end

          m = Proto::TYPE[data[1]].is_a?(Class) ?  Proto::TYPE[data[1]].allocate : allocate
          m.decode(header, data, body)
          m
        end

        def type(code = nil)
          return @type if code.nil?
          TYPE[code] = self
          @type = code
        end
      end

      attr_reader :header, :data, :body


      def initialize(type, body = "")
        @data   = [4542, self.class.type || 0x80, 0, 0] # defaults to a ping request
        @header = [Proto::VERSION, 0, 0, 6]
        self.type = type if type
        self.body = body
      end

      def encode(tag, seq = nil)
        # TODO support ack messages: 7th bit of 4th element (class of message) should be 1
        # TODO determine IANA enterprise number from message type
        sequence = seq if seq
        self.tag = tag
        (@header  + [data[0], data[1], data[2], data[3], data[4]]).pack(FORMAT) + (@body)
      end

      # @api private
      def decode(header, data, body)
        @header = header
        @data   = data
        @body   = body
      end

      def sequence=(seq)
        @header[2] = seq
      end

      def tag=(tag)
        @data[2] = tag
      end

      def asf?
        (@header[3] & 6) == 6
      end

      def ipmi?
        (@header[3] & 7) == 7
      end

      def ipmi!
        ((@header[3] >> 3) << 3) | 7
        sequence = 0xff
        self
      end

      def asf!
        ((@header[3] >> 3) << 3) | 6
        self
      end

      def ack?
        (@header[3] & (2**7)) > 0
      end

      def type
        Proto::TYPE[@data[1]]
      end

      def type=(sym)
        return @data[1] = sym if sym.is_a?(Fixnum)
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
require "rmcp/proto/message/ping"
require "rmcp/proto/message/capabilities"
