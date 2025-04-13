# DataBridge Shared

The `databridge_shared` gem provides common utilities, event schemas, and client libraries for the DataBridge system - a solution for seamless data sharing across multiple applications within an organization.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'databridge_shared'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install databridge_shared
```

## Features

This gem provides shared functionality for all DataBridge microservices:

- **Event Schemas**: Standardized JSON schema definitions for all events
- **Authentication**: JWT-based authentication utilities
- **Event Publishing/Subscribing**: Client libraries for event-driven communication
- **Logging**: Standardized logging formatters

## Usage

### Event Publishing

```ruby
require 'databridge_shared'

# Initialize the publisher with your broker configuration
publisher = DataBridgeShared::Clients::EventPublisher.new(
  host: 'kafka.example.com',
  port: 9092
)

# Publish an event
publisher.publish(
  'CustomerCreated', 
  {
    id: '123',
    email: 'customer@example.com',
    name: 'John Doe',
    created_at: Time.now.iso8601
  }
)
```

### Event Subscribing

```ruby
require 'databridge_shared'

# Initialize the subscriber with your broker configuration
subscriber = DataBridgeShared::Clients::EventSubscriber.new(
  host: 'kafka.example.com',
  port: 9092
)

# Create a handler class
class CustomerEventHandler
  def handle(event)
    puts "Received event: #{event}"
  end
end

# Subscribe to events
subscriber.subscribe(
  ['CustomerCreated', 'CustomerUpdated'],
  CustomerEventHandler.new
)
```

### Authentication

```ruby
require 'databridge_shared'

# Generate a JWT token
token = DataBridgeShared::Auth::JwtHelper.encode(
  { user_id: 123 }, 
  ENV['JWT_SECRET_KEY']
)

# Decode and verify a token
decoded_payload = DataBridgeShared::Auth::JwtHelper.decode(
  token, 
  ENV['JWT_SECRET_KEY']
)
```

## Available Event Schemas

The gem includes standardized schemas for common events:

- `CustomerCreated`
- `CustomerUpdated`
- `OrderCreated`
- `OrderStatusChanged`
- `ProductCreated`
- `ProductUpdated`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome. This project is intended to be a safe, welcoming space for collaboration.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).