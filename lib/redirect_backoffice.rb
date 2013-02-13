# See http://www.packtpub.com/article/building-tiny-web-applications-in-ruby-using-sinatra

require "redirect_backoffice/version"
# require 'rack/ssl'


require 'webrick'
require 'webrick/https'
# require 'openssl'

# set :public_folder, File.dirname(__FILE__) + '/../public'
set :run, false

module RedirectBackoffice

# --- private functions ---
private

  def self.load_yaml(filename)
    if File.file? filename
        begin
          YAML::load_file(filename)
        rescue StringIndexOutOfBoundsException => e
          puts "Error: YAML parsing in #{filename}"
          write_log "Error: YAML parsing in #{filename}"
          write_log e.message
          raise "YAML not parsable"
          false
        rescue Exception => e
          puts "Error: YAML parsing in #{filename}"
          write_log "Error: YAML parsing in #{filename}"
          write_log e.message
          raise "YAML not parsable"
          false
        end
    else
      raise "File not found: #{filename}"
    end
  end

  def write_log(message)
    puts message
  end

  # Your code goes here...
  rc_file = File.join(ENV["HOME"] , ".redirect_backoffice.yaml")
  backoffice_config = load_yaml(rc_file)
  # set :bind, backoffice_config["ip"] || "127.0.0.1"
  # set :port, backoffice_config["port"] || "8089"

class MyServer  < Sinatra::Base
#    post '/' do
#      "Hello, world!\n"
#    end            
end

CERT_PATH = backoffice_config["cert_path"] || '/opt/myCA/server/'

webrick_options = {
  :Port               => backoffice_config["port"] || 8443,
  :Host               => backoffice_config["ip"] || "127.0.0.1",
#  :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
  :Logger             => WEBrick::Log::new(backoffice_config["logfile"], WEBrick::Log::DEBUG),
  :DocumentRoot       => File.dirname(__FILE__) + '/../public',
  :SSLEnable          => true,
  :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
  :SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, backoffice_config["hostname"] + ".cert")).read),
  :SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(CERT_PATH, backoffice_config["hostname"] + ".key")).read),
  :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ],
  :app                => MyServer
}

Rack::Server.start webrick_options

end
