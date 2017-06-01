require 'mongo'
require 'virtus'
require 'fish0/version'
require 'fish0/configuration'
require 'fish0/engine'
require 'fish0/exceptions'
require 'fish0/repository'
require 'fish0/paginator'
require 'fish0/concerns/cacheable'
require 'fish0/concerns/equalable'
require 'fish0/concerns/paginatable'
require 'fish0/concerns/view_model'
require 'fish0/concerns/base'
require 'fish0/collection'
require 'fish0/model'

module Fish0
  class << self
    def mongo_reader
      Mongo::Logger.logger = mongo_config['logger'] || Rails.logger
      @mongo_reader ||= begin
        Mongo::Client.new(mongo_config[:mongo_uri] || mongo_config[:hosts], mongo_config[:params])
      end
    end

    def mongo_config
      if File.file?(File.expand_path('../config/mongo.yml', __FILE__))
        config = Rails.application.config_for(:mongo)
        Configuration.mongo_uri = config['mongo_uri']
        Configuration.mongo_hosts = config['hosts']
        Configuration.mongo_params = config['params']
      end
      @mongo_config || { hosts: Configuration.mongo_hosts,
                         params: Configuration.mongo_params,
                         mongo_uri: Configuration.mongo_uri }
    end
  end
end
