I'll help you create a README.md for the customer service component of your DataBridge system. Let me analyze the existing files to understand the customer service functionality first.

Based on the files you've shared, the customer service is part of a larger microservices architecture with event-driven communication. It handles customer data management including authentication, customer profiles, addresses, and preferences.

Here's a README.md for the customer service:

# DataBridge Customer Service

The Customer Service is a core microservice in the DataBridge architecture, responsible for managing customer data across the platform. It provides APIs for customer authentication, profile management, addresses, and customer preferences.

## Overview

The Customer Service is built using Ruby on Rails in API-only mode, implementing an event-driven architecture to notify other services of changes to customer data. It's part of the larger DataBridge system which enables seamless data sharing across multiple applications.

## Features

- **Customer Management**: Create, read, update, and deactivate customer accounts
- **Authentication**: JWT-based authentication system
- **Address Management**: Store and manage multiple addresses per customer
- **Preference Management**: Store customer preferences as key-value pairs
- **Event Publishing**: Publishes events when customer data changes

## API Endpoints

### Authentication
- `POST /api/auth/login`: Authenticate a customer
- `POST /api/auth/register`: Register a new customer

### Customers
- `GET /api/customers`: List all customers (admin only)
- `GET /api/customers/:id`: Get a specific customer
- `POST /api/customers`: Create a new customer
- `PUT /api/customers/:id`: Update a customer
- `DELETE /api/customers/:id`: Deactivate a customer

### Addresses
- `GET /api/customers/:customer_id/addresses`: List customer addresses
- `POST /api/customers/:customer_id/addresses`: Create a new address
- `GET /api/customers/:customer_id/addresses/:id`: Get a specific address
- `PUT /api/customers/:customer_id/addresses/:id`: Update an address
- `DELETE /api/customers/:customer_id/addresses/:id`: Delete an address

### Preferences
- `GET /api/customers/:customer_id/preferences`: List customer preferences
- `GET /api/customers/:customer_id/preferences/:id`: Get a specific preference
- `PUT /api/customers/:customer_id/preferences/:id`: Update a preference
- `DELETE /api/customers/:customer_id/preferences/:id`: Delete a preference

## Data Models

### Customer
- `email`: Email address (unique)
- `name`: Full name
- `password`: Encrypted password
- `role`: User role (customer, admin, staff)
- `status`: Account status (active, inactive, suspended)
- `last_login_at`: Last login timestamp

### Address
- `customer_id`: Associated customer
- `address_type`: Type of address (shipping, billing)
- `street`: Street address
- `city`: City
- `state`: State/province
- `postal_code`: ZIP/Postal code
- `country`: Country
- `is_default`: Whether this is the default address of its type

### Preference
- `customer_id`: Associated customer
- `key`: Preference name
- `value`: Preference value

## Event Publishing

The service publishes the following events to notify other services about changes:

- `CustomerCreated`: When a new customer is registered
- `CustomerUpdated`: When customer details are modified
- `CustomerPreferenceChanged`: When a customer preference is updated

## Setup & Installation

### Prerequisites
- Ruby 3.2.2
- Rails 7.1
- PostgreSQL
- Kafka/RabbitMQ for event messaging

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-org/databridge-customer-service.git
   cd databridge-customer-service
   ```

2. Install dependencies:
   ```
   bundle install
   ```

3. Setup the database:
   ```
   rails db:create db:migrate db:seed
   ```

4. Configure environment variables:
   ```
   cp .env.example .env
   # Edit .env with your configuration
   ```

5. Start the server:
   ```
   rails s -p 3001
   ```

## Testing

Run the test suite with:

```
rails spec
```

## Dependencies

- `databridge_shared`: Shared utilities for the DataBridge platform
- `jwt`: For JWT authentication
- `kafka-ruby`: For event publishing

## Integration with Other Services

The Customer Service interacts with other DataBridge services:
- **API Gateway**: Routes customer-related requests to this service
- **Order Service**: Consumes customer events to update order data
- **Analytics Service**: Consumes customer events for reporting

## Development

### Adding New Events

1. Define the event schema in `databridge_shared` gem
2. Add the publishing code to the relevant model
3. Create handlers in consuming services

## Related Services

- [DataBridge API Gateway](https://github.com/Niraj22/databridge-api-gateway)
- [DataBridge Order Service](https://github.com/Niraj22/databridge-order-service)
- [DataBridge Product Service](https://github.com/Niraj22/databridge-product-service)

## License

[MIT License](LICENSE)
