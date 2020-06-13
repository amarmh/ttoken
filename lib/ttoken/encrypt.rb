require 'openssl'
class Encrypt
  CIPHER = OpenSSL::Cipher.new('aes-256-cbc')

  def encrypt_pin(pin)
    if is_encryptable?(pin)
      cipher = CIPHER.encrypt
      cipher.key = encryption_key
      s = cipher.update(pin) + cipher.final
      s.unpack('H*')[0].upcase
    end
  end

  def decrypt_pin(pin)
    if is_decryptable?(pin)
      cipher = CIPHER.decrypt
      cipher.key = encryption_key
      s = [pin].pack("H*").unpack("C*").pack("c*")
      begin
        cipher.update(s) + cipher.final
      rescue StandardError => e
      raise "\n Problem in decrypting password. To resolve the issue encrypt and save the password again using command # ttoken --encrypt. \n Error: #{e.message}"
      end
    end
  end

  def is_encryptable?(str)
    !encryption_key.nil? && !str.nil?
  end

  def is_decryptable?(str)
    !encryption_key.nil? && !str.nil?
  end

  def encryption_key
    if File.exist?(ENCRYPTION_KEY_FILE)
      Store.retrive_encryption_key
    else
      key = CIPHER.random_key
      Store.save_encryption_key(key)
      key
    end
  end
end