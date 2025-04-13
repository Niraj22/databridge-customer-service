# frozen_string_literal: true

# spec/databridge_shared/clients/event_subscriber_spec.rb
require "spec_helper"

RSpec.describe DataBridgeShared::Clients::EventSubscriber do
  let(:subscriber) { described_class.new }

  describe "#subscribe" do
    it "subscribes to events" do
      event_names = ["test_event"]
      handler = double("handler")

      expect { subscriber.subscribe(event_names, handler) }.not_to raise_error
    end
  end
end
