module IPMI
  class Proto
    class << self
      HEADER_FORMAT = "CCCCCNNQ>Q>C"
      def decode(packet)
        header = packet.unpack(HEADER_FORMAT)
        $stderr.puts "IPMI header: #{header}"
        $stderr.puts "  payload length: #{header[-1]}"
      end
    end
  end # class::Proto
end # module::IPMI
