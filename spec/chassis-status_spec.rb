require_relative "spec_helper"
require "rmcp"

describe "Chassis Power Parser" do
  let(:messages) do
    RMCP::Test.fixture("chassis-status")
  end

  RMCP::Test.fixture("chassis-status").each_with_index do |m,i|
    describe "message #{i + 1}" do
      it "should parse message ##{i + 1}" do
        RMCP::Proto.decode(m)
      end

      describe "the parsed message #{i + 1}" do
        subject { RMCP::Proto.decode(m) }
        it { should be_a RMCP::Proto::Message }
        its(:body) { should be_a IPMI::Message }
        its(:ipmi?) { should be_true }
        its(:type) { should be_nil }
        its(:asf?) { should be_true }
      end
    end
  end

  describe "the first message body" do
    let(:message) { RMCP::Proto.decode(messages.first) }
    subject { message.body }
    its(:session_header) { should be_a IPMI::Session::Header }

    describe "#session_header" do
      subject { message.body.session_header }
      its(:auth_type) { should be_nil }
      its(:sequence) { should == 0 }
      its(:sid) { should == 0 }
      its(:length) { should == 9 }
      its(:payload) { should be_a IPMI::Session::Header::Payload}

      describe "session_header#payload" do
        subject { message.body.session_header.payload }
        its(:type) { should be_nil }
      end
    end

    its(:header) { should be_a IPMI::Message::Header }
    describe "#header" do
      subject { message.body.header }
      its(:cmd) { should == 0x38 }
      its(:net_fn) { should == 0x06 }
      its(:rs_addr) { should == 0x20 }
      its(:rs_lun) { should == 0 }
      its(:rq_addr) { should == 0x81 }
      its(:rq_lun) { should == 0 }
    end
  end

  describe "the second message body" do
    let(:message) { RMCP::Proto.decode(messages[1]) }
    subject { message.body }
    its(:session_header) { should be_a IPMI::Session::Header }

    describe "#session_header" do
      subject { message.body.session_header }
      its(:auth_type) { should be_nil }
      its(:sequence) { should == 0 }
      its(:sid) { should == 0 }
      its(:length) { should == 16 }
      its(:payload) { should be_a IPMI::Session::Header::Payload}

      describe "session_header#payload" do
        subject { message.body.session_header.payload }
        its(:type) { should be_nil }
      end
    end

    its(:header) { should be_a IPMI::Message::Header }
    describe "#header" do
      subject { message.body.header }
      its(:cmd) { should == 0x38 }
      its(:net_fn) { should == 0x07 }
      its(:rs_addr) { should == 0x81 }
      its(:rs_lun) { should == 0 }
      its(:rq_addr) { should == 0x20 }
      its(:rq_lun) { should == 0 }
    end
  end

  describe "the third message body" do
    let(:message) { RMCP::Proto.decode(messages[2]) }
    subject { message.body }
    it { should be_a IPMI::Message::OpenSessionRequest }
    its(:session_header) { should be_a IPMI::Session::Header }

    describe "#session_header" do
      subject { message.body.session_header }
      its(:auth_type) { should == :rmcpp }
      its(:sequence) { should == 0 }
      its(:sid) { should == 0 }
      its(:length) { should == 32 }
      its(:payload) { should be_a IPMI::Session::Header::Payload}

      describe "session_header#payload" do
        subject { message.body.session_header.payload }
        its(:type) { should == :rmcpp_open_session_req }
        its(:encrypted) { should be_false }
        its(:authenticated) { should be_false }
      end
    end

    its(:header) { should be_nil  }
    its(:max_priv) { should == :admin }
    its(:tag) { should == 0 }
    its(:console_sid) { should == 1144201745 }
    its(:auth_type) { should == 0 }
    its(:auth_algo) { should == :rackp_sha1 }
  end
end
