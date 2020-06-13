require "ttoken/version"
require 'rotp'
require 'clipboard'
require 'io/console'

module Ttoken
  require 'ttoken/config'
  require 'ttoken/encrypt'
  require 'ttoken/store'

  class << self
    attr_accessor :config

    def setup
      self.config = Config.new
    end

    def run
      encrypt = Encrypt.new
      if ARGV.length > 0 &&  ARGV[0] == '--encrypt'
        pin = STDIN.getpass("Password/Pin:")
        encrypted_pin = encrypt.encrypt_pin(pin)
        Store.save_password(encrypted_pin)
      else
        token = generate_token(config.token, config.issuer)
        if config.pinplustoken
          password = Store.retrive_password
          decrypted_pin = encrypt.decrypt_pin(password)
          send_to_clipboard(decrypted_pin + token)
        else
          send_to_clipboard(token)
        end
      end
    end

    def generate_token(token, issuer)
      begin
        ROTP::TOTP.new(token, issuer: issuer).now
      rescue StandardError => e
        raise " \nSomething went wrong. Please check if all parameters in /etc/ttoken/ttoken.yml are correct.\n Error: #{e.message}"
      end
    end

    def send_to_clipboard(text)
      begin
        system("echo -n #{text} | xclip -selection clipboard")
        puts 'Data copied to clipboard. Ready to paste.'
      rescue StandardError => e
        raise "Problem in copying data to clipboard. Error: #{e.message}"
      end
    end

  end
end