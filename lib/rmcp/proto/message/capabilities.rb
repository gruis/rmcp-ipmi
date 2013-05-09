module RMCP
  class Proto
    class Message
      class Capabilities < Message::Base
        type 0x41

        class << self
          def request
            Message.new(0x81)
          end
        end # class << self

      end # class::Capabilities < Message
    end # class::Message
  end # class::Proto
end # module::RMCP
