# require 'money/bank/open_exchange_rates_bank'
#
# MoneyRails.configure do |config|
#   oxr = Money::Bank::OpenExchangeRatesBank.new
#   oxr.app_id = ENV['OPEN_EXCHANGE_RATES_APP_ID']
#   oxr.cache = Rails.root.join('tmp', 'exchange_rates.json')
#   oxr.update_rates
#   config.default_bank = oxr
# end