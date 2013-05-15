require "ipmi/session/header"
require "ipmi/message/header"
require "ipmi/message/open-session-request"

module IPMI
  class Message
    class << self
      def decode(msg)
        session_header   = Session::Header.new.decode(msg)
        # TODO instantiate based on cmd code
        if session_header.payload.type == :rmcpp_open_session_req
          m  = OpenSessionRequest.new.decode(session_header.payload.body)
        else
          m        = new
          m.header = Header.new.decode(session_header.payload.body)
        end
        m.session_header = session_header
        m
      end
    end # class << self

    attr_reader :session_header, :header

    def session_header=(h)
      @session_header = h.is_a?(Session::Header) ? h : Session::Header.new.decode(h)
    end

    def header=(h)
      @header = h.is_a?(Header) ? h : Header.new.decode(h)
    end

    def encode
      [0,0,0,0,0]
    end

  end # class::Message
end # module::IPMI
