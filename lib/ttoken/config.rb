require 'yaml'
module Ttoken
  class Config
    attr_accessor :config_file, :token, :issuer, :pinplustoken

    def initialize
      @config_file = config_file_path
      @options = load_config
      @token = @options.fetch(:token, nil)
      @issuer = @options.fetch(:issuer, nil)
      @pinplustoken = @options.fetch(:pinplustoken, false)
    end

    def config_file_path
      File.exist?(CONFIG_FILE) ? CONFIG_FILE : File.join(source_path, 'config/ttoken.yml')
    end

    def load_config
      if File.exist?(config_file)
        YAML.load(File.open(config_file)) || {}
      else
        puts "Config file #{config_file} not found, using default configuration"
        {}
      end
    rescue StandardError => e
      raise "Couldn't load configuration file. Error: #{e.message}"
    end

    def source_path
      File.expand_path('../../..', __FILE__)
    end

  end
end