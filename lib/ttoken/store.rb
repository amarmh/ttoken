require 'yaml'
class Store
  PASSWORD_FILE = File.expand_path('~/.ttoken/ttoken.yml')

  def self.save_password(password)
    create_dir
    data = {password: password}
    begin
      File.write(PASSWORD_FILE, data.to_yaml)
      puts 'Password saved successfully. Use command #ttoken to generate pin+token'
    rescue StandardError => e
      raise "Unable to write password file. Error: #{e.message}"
    end
  end

  def self.retrive_password
    if File.exist?(PASSWORD_FILE)
      pf = YAML.load(File.read(PASSWORD_FILE))
      pf[:password]
    else
      puts 'Password file does not exits. Save the password/pin using command # ttoken --encrypt'
      exit 2
    end
  end

  def self.retrive_encryption_key
    if File.exist?(ENCRYPTION_KEY_FILE)
      pf = YAML.load(File.read(ENCRYPTION_KEY_FILE))
      pf[:encryption_key]
    end
  end

  def self.save_encryption_key(encryption_key)
      create_dir
      data = {encryption_key: encryption_key}
      File.write(ENCRYPTION_KEY_FILE, data.to_yaml)
  end

  def self.create_dir
    dir = File.expand_path('~/.ttoken')
    Dir.mkdir(dir) unless Dir.exist?(dir)  
  end

end
