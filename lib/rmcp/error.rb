module RMCP
  module Error
    class StandardError < ::StandardError
      include Error
    end
    class ProtocolError < StandardError; end
  end # module::Error
end # module::RMCP
