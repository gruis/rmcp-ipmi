module IPMI
  class Message
    # IPMI Specification page 143
    class OpenSessionRequest < Message
      PRIVS = [
        :highest,
        :callback,
        :user,
        :operator,
        :admin,
        :oem
      ]
      AUTH_ALGOS = [
        :rakp_none,
        :rackp_sha1,
        :rackp_md5
      ]
      AUTH_ALGOS[0xc0..0xff] = (0xff-0xc0).times.map{ :oem }

      attr_reader :tag, :max_priv, :console_sid, :auth_type, :auth_algo

      def decode(packet)
        @tag, @max_priv, _, @console_sid = packet.unpack("CCnN")
        packet    = packet[8..-1]
        @max_priv = PRIVS[@max_priv]
        @auth_type, _, auth_len, @auth_algo = packet.unpack("CnCC")
        packet    = packet[16..-1]
        @auth_algo = AUTH_ALGOS[@auth_algo]
        self
      end

    end # class::Header
  end # class::Message
end # module::IPMI
