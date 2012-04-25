require 'active_record'
require 'acts-as-savable'
require 'database_cleaner'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
DatabaseCleaner.strategy = :transaction

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.alias_it_should_behave_like_to :include_examples

  config.before(:each)  { DatabaseCleaner.start }
  config.after( :each)  { DatabaseCleaner.clean }
end
