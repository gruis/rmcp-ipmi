module RMCP
  class Proto
    class Message
      class Ping < Message::Base
        type 0x80

        def type
          self.class.type
        end

        def body
          ""
        end

        def msg_class
          6
        end

      end # class::Pong < Message
    end # class::Message
  end # class::Proto
end # module::RMCP
