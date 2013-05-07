module RMCP
  class Proto
    VERSION = 6

    TYPE = 15.times.map{ :reserved }
    # 0x10:0x3F - "Set" commands
    TYPE[0x10] = :reset
    TYPE[0x11] = :powerup
    TYPE[0x12] = :powerdown_hard

    # 0x40:0x7f - Response or "Get Response" commands
    TYPE[0x40] = :pong
    TYPE[0x41] = :resp_cap
    TYPE[0x42] = :resp_sys_state

    # 0x80:0xbf - Reqeust or "Get" commands
    TYPE[0x80] = :ping
    TYPE[0x81] = :req_cap
    TYPE[0x82] = :req_sys_sate

    class << self
      def decode(packet)
        Message.decode(packet)
      end # decode(packet)
    end # class << self

  end # class::Proto
end # module::RMCP

require "rmcp/proto/message"
