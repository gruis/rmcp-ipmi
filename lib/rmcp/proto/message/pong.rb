module RMCP
  class Proto
    class Message
      class Pong < Message::Base
        FORMAT = "NNCCN"
        type 0x40


        def initialize(body = "")
          super(body)
          @iana, @oem, @entity_mask, @inter_mask, @res = body.unpack(FORMAT)
        end

        def support_ipmi?
          (@entity_mask & (2**7)) > 0
        end

        def support_asf_v1?
          (@entity_mask & 1) > 0
        end

        def support_sec_ext?
          (@inter_mask & (2**7)) > 0
        end

      end # class::Pong < Message
    end # class::Message
  end # class::Proto
end # module::RMCP
