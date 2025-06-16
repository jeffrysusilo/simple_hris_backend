require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HrDashboardApi
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    config.api_only = true

    # ✅ Tambahkan ini untuk mengizinkan CORS request dari frontend
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:5173'  # Ganti sesuai asal frontend kamu

        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          expose: ['Authorization']  # Tambahan jika kamu pakai token di header
      end
    end
  end
end