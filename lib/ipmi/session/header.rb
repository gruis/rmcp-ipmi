module IPMI
  class Session
    class Header
      AUTH_FMT = [nil, :md2, :md5, :reserved, :straight, :oem, :rmcpp]
      attr_reader :auth_type, :sequence, :sid, :length, :payload, :trailer

      def decode(packet)
        auth = packet[0].unpack("C")[0] & 15
        @auth_type = :reserved if auth > AUTH_FMT.length
        @auth_type = AUTH_FMT[auth]
        packet     = packet[1..-1]
        @payload   = Payload.new

        if @auth_type == :rmcpp
          @payload.type, packet = packet[0].unpack("C")[0], packet[1..-1]
          if @payload.type == :oem
            oem_iana, oem_payload_id = packet[0...10].unpack("NnN")
            packet                  = packet[10..-1]
          end
          @sid, @sequence, @length = packet[0...15].unpack("CNnNNn")
          @payload.body, @trailer = packet[15..@length] = packet[15+@length .. -1]

        else # Not RMCP+ IPMI 2.0
          @sequence, @sid = packet[0...8].unpack("NN")
          packet = packet[8..-1]
          if !@auth_type.nil?
            @auth_code, packet = packet[0...16].unpack("NNNN"), packet[16..-1]
          end
          @length, packet  = packet[0].unpack("C")[0], packet[1..-1]
          @payload.body, @trailer = packet[0 ... @length], packet[@length .. -1]
        end
        self
      end

      class Payload
        TYPES = [ :ipmi, :sol, :oem ]
        TYPES[10] = :rmcpp_open_session_req
        TYPES[11] = :rmcpp_open_session_res
        TYPES[12] = :rackp_m1
        TYPES[13] = :rackp_m2
        TYPES[14] = :rackp_m3
        TYPES[15] = :rackp_m4
        TYPES[20] = :oem_0
        TYPES[21] = :oem_2
        TYPES[23] = :oem_3
        TYPES[24] = :oem_4
        TYPES[25] = :oem_5
        TYPES[26] = :oem_6
        TYPES[27] = :oem_7

        attr_accessor :type, :pid, :body

        def type=(t)
          if t.is_a?(Fixnum)
            @encypted      = t & 128 > 0
            @authenticated = t & 64 > 0
            @type = TYPES[t & 63] || :reserved
          else
            @type = t
          end
        end

        def encrypted?
          @encrypted == true
        end

        def authenticated
          @authenticated == true
        end
      end

    end # class::Header
  end # class::Session
end # module::IPMI
