module RMCP
  class Proto
    class Message
      class Base < Message

        undef_method :msg_class=, :body=, :type=

        def initialize(body = "")
          @body      = body
        end

        def type
          self.class.type
        end

      end # class::Base < Message
    end # class::Message
  end # class::Proto
end # module::RMCP
