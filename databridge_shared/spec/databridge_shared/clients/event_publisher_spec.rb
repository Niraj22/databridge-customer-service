# frozen_string_literal: true

require "spec_helper"

RSpec.describe DataBridgeShared::Clients::EventPublisher do
  let(:publisher) { described_class.new }

  describe "#publish" do
    it "publishes an event to the broker" do
      event_name = "test_event"
      payload = { id: "123", name: "Test" }

      expect { publisher.publish(event_name, payload) }.not_to raise_error
    end
  end
end
