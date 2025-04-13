# frozen_string_literal: true

require "spec_helper"

RSpec.describe DataBridgeShared::Auth::JwtHelper do
  let(:payload) { { user_id: 123, exp: Time.now.to_i + 3600 } }
  let(:secret) { "test_secret_key" }

  describe ".encode" do
    it "encodes a payload into a JWT token" do
      token = described_class.encode(payload, secret)
      expect(token).to be_a(String)
      expect(token.split(".").length).to eq(3)
    end
  end

  describe ".decode" do
    it "decodes a valid token back to the original payload" do
      token = described_class.encode(payload, secret)
      decoded = described_class.decode(token, secret)
      expect(decoded.first["user_id"]).to eq(payload[:user_id])
    end

    it "returns nil for an invalid token" do
      expect(described_class.decode("invalid.token.string", secret)).to be_nil
    end
  end
end
