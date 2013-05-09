module RMCP
  class Proto
    VERSION = 6

    TYPE = {}
    # 0x10:0x3F - "Set" commands
    TYPE[:reset]          = 0x10
    TYPE[:powerup]        = 0x11
    TYPE[:powerdown_hard] = 0x12

    # 0x40:0x7f - Response or "Get Response" commands
    TYPE[:pong]           = 0x40
    TYPE[:resp_cap]       = 0x41
    TYPE[:resp_sys_state] = 0x42

    # 0x80:0xbf - Reqeust or "Get" commands
    TYPE[:ping]          = 0x80
    TYPE[:req_cap]       = 0x81
    TYPE[:req_sys_state] = 0x82

    class << self

      def decode(packet)
        Message.decode(packet)
      end

      def type(t)
        return TYPE[t] unless t.is_a?(Fixnum)
        klass = type_class(t)
        return klass if klass
        candidates = TYPE.find{|k,v| v == t }
        candidates && candidates[0]
      end

      def type_class(t)
        tc = TYPE.find{|k,v| k.is_a?(Class) && v == t}
        tc && tc[0]
      end

    end # class << self

  end # class::Proto
end # module::RMCP

require "rmcp/proto/message"
