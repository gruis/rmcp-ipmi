module RMCP
  class Proto
    class Message
      class Ping < Message
        type 0x80

        def initialize
          super(nil)
        end
      end # class::Pong < Message
    end # class::Message
  end # class::Proto
end # module::RMCP
