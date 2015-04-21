require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Continuous
  class Application < Rails::Application
    # config.time_zone = 'Central Time (US & Canada)'
    config.ldapenabled = true
    config.ldapbase = "dc=example,dc=com"
    config.ldap = "ldap.example.com"
    config.ldapport = 389
    config.ldapou = "ou=People,dc=example,dc=com"
    config.adminpassword = "adminpassword"
    config.queuehost = "1.1.1.1"
    config.queuevhost = "/continuous"
    config.queueuser = "rabbitmquser"
    config.queuepassword = "rabbitmqpassword"
    config.mistralhost = "1.1.1.1"
    config.mesoshost = "1.1.1.1"
    config.sensuhost = "1.1.1.1"
    config.cistackdomain = "cicd.example.com"
    config.continuousfqdn = "continuous.example.com"
    config.dockerregistry = "continuous-registry.example.com"
    config.dashboardserver = "dashboard.example.com"
    config.repositoryserver = "repository.example.com"
  end
end
