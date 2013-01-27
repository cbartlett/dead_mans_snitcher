require 'net/https'
require 'uri'

class DeadMan

  def self.snitch(id, &block)
    dead_man = new(id)
    block.call
    dead_man.snitch
  end

  def initialize(id)
    @id = id
    @start_time = Time.now
  end

  def elapsed_time
    (Time.now - @start_time).round
  end

  def uri
    URI.parse("https://nosnch.in/#{@id}?m=#{elapsed_time}+seconds")
  end

  def http
    Net::HTTP.new(uri.host, uri.port).tap do |http|
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def snitch
    http.get(uri.request_uri)
  end

end
