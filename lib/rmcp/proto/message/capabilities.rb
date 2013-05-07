module RMCP
  class Proto
    class Message
      class Capabilities < Message
        type 0x41

        def initialize
          super(nil)
        end

      end # class::Capabilities < Message
    end # class::Message
  end # class::Proto
end # module::RMCP

