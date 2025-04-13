# frozen_string_literal: true

module DataBridgeShared
  module EventSchemas
    CUSTOMER_CREATED = {
      "type" => "record",
      "name" => "CustomerCreated",
      "fields" => [
        { "name" => "id", "type" => "string" },
        { "name" => "email", "type" => "string" },
        { "name" => "name", "type" => "string" },
        { "name" => "created_at", "type" => "string" }
      ]
    }.freeze

    CUSTOMER_UPDATED = {
      "type" => "record",
      "name" => "CustomerUpdated",
      "fields" => [
        { "name" => "id", "type" => "string" },
        { "name" => "email", "type" => %w[string null] },
        { "name" => "name", "type" => %w[string null] },
        { "name" => "updated_at", "type" => "string" }
      ]
    }.freeze
  end
end
