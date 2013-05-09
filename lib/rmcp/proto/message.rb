
module RMCP
  class Proto
    # @example reuse message objects
    #   m = Proto::Message::Ping.new
    #   send_datagram(m.tag!(1).seq!(1).encode, @addr, @port)
    #   send_datagram(m.tag!(0x12).seq!(1).encode, @addr, @port)
    #
    # @example create custom message types
    #   # Request Capabilities message
    #   m = Proto::Message.new(0x81)
    #   send_datagram(m.seq!(1).tag!(2).encode, @addr, @port)
    #
    # @example create message by symbol
    #   # Request Capabilities message
    #   m = Proto::Message.new(:req_cap)
    #   send_datagram(m.seq!(1).tag!(2).encode, @addr, @port)
    #
    # @example parse a recieved message
    #   msg = Proto.decode(packet)
    #   # => Proto::Message
    #   msg.type
    #   # => :resp_cap
    #   msg.code
    #   # => 0x41
    #
    # @example parse a recieved message with a local class implementation
    #   msg = Proto.decode(packet)
    #   # => Proto::Message::Pong
    #   msg.type
    #   # => :pong
    #   msg.code
    #   # => 0x40
    #   msg.ack?
    #   # => true
    #
    # @example parse a received ipmi message
    #   msg = Proto.decode(packet)
    #   # => Proto::Message
    #   msg.type
    #   # => nil
    #   msg.ack?
    #   # => false
    #   msg.ipmi?
    #   # => true
    #   msg.data
    #   # => ::IPMI::Message
    #
    # @example create an IPMI message encapsulated in an RMCP message
    #   i = IPMI::Message.new("...")
    #   m = Proto::Message.new(i)
    #   m.ipmi?
    #   # => true
    #   msg.data
    #   # => ::IPMI::Message
    #   end_datagram(m.seq!(1).tag!(2).encode, @addr, @port)
    class Message
      HEADER_FMT = "CCCC"
      DATA_FMT   = "NCCCC"

      attr_reader :type
      attr_accessor :body, :sequence, :tag
      attr_writer :msg_class, :iana_num

      class << self
        def decode(packet)
          header, body = packet[0...4].unpack(HEADER_FMT), packet[4..-1]
          if ipmi?(header[3])
            body = ::IPMI::Message.decode(body)
            m = new(body)
          else
            data_header, body = body[0...8].unpack(DATA_FMT), body[8..-1]
            type = data_header[1]
            tag  = data_header[2]
            m    = Proto.type_class(type) ? Proto.type_class(type).new(body) : new(type, body)
            m.tag!(tag)
          end
          m.seq!(header[2])
          m
        end


        def type(code = nil)
          return @type if code.nil?
          TYPE[self] = code
          @type = code
        end

        def ipmi?(msg_class)
          (msg_class & 7) == 7
        end
      end # class << self

      def initialize(type, body = "")
        if type.is_a?(::IPMI::Message)
          ipmi!
          self.body = type
        else
          self.type = type
          self.body = body
        end
      end

      def msg_class
        @msg_class ||= 6
      end

      def iana_num
        @iana_num ||= 4542
      end

      def asf!
        ((msg_class >> 3) << 3) | 6
        sequence = 0 if sequence == 0xff
        self
      end

      def ack?
        (msg_class & (128)) > 0
      end

      def ack!
        msg_class = (msg_class | (128))
      end

      def asf?
        (msg_class & 6) == 6
      end

      def ipmi?
        (msg_class & 7) == 7
      end

      def ipmi!(body = nil)
        self.msg_class = (((self.msg_class >> 3) << 3) | 7)
        self.sequence = 0xff
        self.tag      = nil
        raise ArgumentError.new("Expected body to be an IPMI::Message") if body && !body.is_a?(::IPMI::Message)
        self.body = body
        self
      end

      def type!(sym)
        type = sym
        self
      end

      def type=(sym)
        return @type = sym if sym.is_a?(Fixnum)
        raise ArgumentError.new("unrecognized type: #{sym.inspect}") unless (t = Proto.type(sym))
        @type = t
      end

      def sequence!(seq)
        raise ArgumentError.new("IPMI message must have #{0xff} as a sequence number") if ipmi? && seq != 0xff
        self.sequence = seq
        self
      end
      alias :seq! :sequence!

      def tag!(tag)
        self.tag = tag
        self
      end

      def body!(b)
        self.body = body
        self
      end

      def body=(b)
        ipmi! if b.is_a?(::IPMI::Message)
        @body = b
      end

      def header
        self.tag      ||= 0
        self.sequence ||= 0
        [Proto::VERSION, 0, self.sequence, self.msg_class]
      end

      def resp?
        type >= 0x40 && type <= 0x7f
      end

      def req?
        (type >= 0x10 && type <= 0x3f) || (type >= 0x80 && type <= 0xbf)
      end

      def get?
        type >= 0x80 && type <= 0xbf
      end

      def set?
        type >= 0x10 && type <= 0x3f
      end

      def len
        body ? body.length : 0
      end

      def encode
        enc           = header.pack(HEADER_FMT)
        return "#{enc}#{body.encode}" if ipmi?
        enc + [iana_num || 4542, type, self.tag, 0, len].pack(DATA_FMT) + (body || "")
      end
      alias :to_s :encode

      def inspect
        to_s.inspect
      end

    end # class::Message
  end # class::Proto
end # module::RMCP

require "rmcp/proto/message/base"
require "rmcp/proto/message/pong"
require "rmcp/proto/message/ping"
require "rmcp/proto/message/capabilities"
