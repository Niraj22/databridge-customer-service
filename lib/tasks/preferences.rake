# lib/tasks/preferences.rake
namespace :preferences do
    desc "Create default preferences for all existing customers who don't have them"
    task create_defaults: :environment do
      # Define default preferences
      default_preferences = {
        'email_notifications': 'true',
        'marketing_emails': 'false',
        'two_factor_auth': 'false',
        'theme': 'light',
        'language': 'en',
        'timezone': 'UTC',
        'currency': 'USD'
      }
      
      # Track statistics
      stats = {
        customers_processed: 0,
        preferences_created: 0,
        errors: 0
      }
      
      # Find all customers
      customers = Customer.all
      
      puts "Starting to create default preferences for #{customers.count} customers..."
      
      # Use a transaction to ensure data consistency
      ActiveRecord::Base.transaction do
        customers.find_each do |customer|
          begin
            stats[:customers_processed] += 1
            
            # Create each preference if it doesn't already exist
            default_preferences.each do |key, value|
              # Skip if this preference already exists for the customer
              next if customer.preferences.exists?(key: key)
              
              # Create the preference
              customer.preferences.create!(key: key, value: value)
              stats[:preferences_created] += 1
            end
            
            # Log progress every 100 customers
            if stats[:customers_processed] % 100 == 0
              puts "Processed #{stats[:customers_processed]} customers..."
            end
          rescue => e
            stats[:errors] += 1
            puts "Error creating preferences for customer ##{customer.id}: #{e.message}"
          end
        end
      end
      
      # Output final statistics
      puts "\nTask completed!"
      puts "Customers processed: #{stats[:customers_processed]}"
      puts "Preferences created: #{stats[:preferences_created]}"
      puts "Errors encountered: #{stats[:errors]}"
    end
    
    desc "Reset all customers to have default preferences (warning: destructive)"
    task reset_all: :environment do
      if Rails.env.production? && !ENV['CONFIRM_DESTRUCTIVE_ACTION']
        puts "This is a destructive action. To run in production, use:"
        puts "CONFIRM_DESTRUCTIVE_ACTION=yes rake preferences:reset_all"
        exit
      end
      
      # Define default preferences
      default_preferences = {
        'email_notifications': 'true',
        'marketing_emails': 'false',
        'two_factor_auth': 'false',
        'theme': 'light',
        'language': 'en',
        'timezone': 'UTC',
        'currency': 'USD'
      }
      
      # Track statistics
      stats = {
        customers_processed: 0,
        preferences_deleted: 0,
        preferences_created: 0,
        errors: 0
      }
      
      # Find all customers
      customers = Customer.all
      
      puts "Starting to reset preferences for #{customers.count} customers..."
      
      # Use a transaction to ensure data consistency
      ActiveRecord::Base.transaction do
        customers.find_each do |customer|
          begin
            stats[:customers_processed] += 1
            
            # Delete all existing preferences
            deleted_count = customer.preferences.delete_all
            stats[:preferences_deleted] += deleted_count
            
            # Create default preferences
            default_preferences.each do |key, value|
              customer.preferences.create!(key: key, value: value)
              stats[:preferences_created] += 1
            end
            
            # Log progress every 100 customers
            if stats[:customers_processed] % 100 == 0
              puts "Processed #{stats[:customers_processed]} customers..."
            end
          rescue => e
            stats[:errors] += 1
            puts "Error resetting preferences for customer ##{customer.id}: #{e.message}"
          end
        end
      end
      
      # Output final statistics
      puts "\nTask completed!"
      puts "Customers processed: #{stats[:customers_processed]}"
      puts "Preferences deleted: #{stats[:preferences_deleted]}"
      puts "Preferences created: #{stats[:preferences_created]}"
      puts "Errors encountered: #{stats[:errors]}"
    end
  end