# frozen_string_literal: true

require "spec_helper"

RSpec.describe DataBridgeShared::EventSchemas do
  describe "CUSTOMER_CREATED" do
    it "has the required fields" do
      schema = DataBridgeShared::EventSchemas::CUSTOMER_CREATED

      expect(schema["name"]).to eq("CustomerCreated")
      expect(schema["type"]).to eq("record")

      field_names = schema["fields"].map { |f| f["name"] }
      expect(field_names).to include("id", "email", "name", "created_at")
    end
  end

  describe "CUSTOMER_UPDATED" do
    it "has the required fields" do
      schema = DataBridgeShared::EventSchemas::CUSTOMER_UPDATED

      expect(schema["name"]).to eq("CustomerUpdated")
      expect(schema["type"]).to eq("record")

      field_names = schema["fields"].map { |f| f["name"] }
      expect(field_names).to include("id", "email", "name", "updated_at")
    end

    it "allows null values for optional fields" do
      schema = DataBridgeShared::EventSchemas::CUSTOMER_UPDATED

      email_field = schema["fields"].find { |f| f["name"] == "email" }
      expect(email_field["type"]).to include("null")

      name_field = schema["fields"].find { |f| f["name"] == "name" }
      expect(name_field["type"]).to include("null")
    end
  end
end
