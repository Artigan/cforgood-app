Geocoder.configure(
  lookup:    :google,
  freegeoip: { host: "freegeoip.net" },
  # ip_lookup: :freegeoip,
  timeout:   20,
  api_key:   ENV['GOOGLE_API_KEY'],
  use_https: true,
  units:     :km       # :km for kilometers or :mi for mile
)
