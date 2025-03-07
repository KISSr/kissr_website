require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)
module Kernel
  def gem_with_pg_fix(dep, *reqs)
    if dep == "pg" && reqs == ["~> 0.15"]
      reqs = ["~> 1.0"]
    end
    gem_without_pg_fix(dep, *reqs)
  end

  # alias_method_chain :gem, :pg_fix
end
# pg 1.0 gem has removed these constants, but 4.2 ActiveRecord still expects them
PGconn   = PG::Connection
PGresult = PG::Result
PGError  = PG::Error

module NewKissr
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      html_tag
    }
  end
end
