require "bundler/setup"

module RMCP
  module Test
    extend self

    def messages(*msgs)
      msgs.flatten
    end

    def fixture(file)
      class_eval IO.read(File.expand_path("../../fixtures/#{file}.rb", __FILE__))
    end
  end
end
