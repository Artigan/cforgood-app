MangoPay.configure do |c|
  c.preproduction = true
  c.client_id = ENV['MANGOPAY_CLIENT_ID']
  c.client_passphrase = ENV['MANGOPAY_CLIENT_PASSPHRASE']
end
