require "ipmi/session/header"
require "ipmi/message/header"

module IPMI
  class Message
    class << self
      def decode(msg)
        session_header   = Session::Header.new.decode(msg)
        header           = Header.new.decode(session_header.payload.body)
        # TODO instantiate based on cmd code
        m                = new
        m.session_header = session_header
        m.header         = header
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
