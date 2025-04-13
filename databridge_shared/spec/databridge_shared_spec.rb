# frozen_string_literal: true

require "spec_helper"

RSpec.describe DataBridgeShared do
  it "has a version number" do
    expect(DataBridgeShared::VERSION).not_to be nil
  end

  it "provides access to event schemas" do
    expect(DataBridgeShared::EventSchemas::CUSTOMER_CREATED).to be_a(Hash)
  end
end
