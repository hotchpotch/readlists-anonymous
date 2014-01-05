require "readlists/anonymous/version"

module Readlists
  class Anonymous
    API_ENDPOINT = 'http://readlists.com/api/v1/readlists/'
    DEFAULT_READLIST_PARAMS = { "is_from_edit_id" => false, "entries" => "[]", "class" => "sharing"}.freeze
    DEFAULT_HEADERS = { 'Content-Type' => 'application/json' }.freeze

    class RequestError < StandardError; end
    def self.request(method, url, params, headers = {})
      headers = DEFAULT_HEADERS.merge headers
      req = case method
            when :get
              Net::HTTP::Get.new(url, headers)
            when :post
              Net::HTTP::Post.new(url, headers)
            when :put
              Net::HTTP::Put.new(url, headers)
            end
      req.basic_auth url.user, url.password if url.user
      req.body = params.to_json
      res = nil
      Net::HTTP.start(url.hostname, url.port, :use_ssl => url.scheme == 'https' ) {|http|
        res = http.request(req)
      }
      raise RequestError.new("#{res.code}: #{res.body}") unless res.code =~ /[234]/
      res
    end

    def self.base_uri
      URI.parse API_ENDPOINT
    end

    def self.create
      res = request(:post, base_uri, DEFAULT_READLIST_PARAMS)
      id, session_id = nil, nil
      res.each_header {|key, value|
        case key
        when 'set-cookie'
          # "sessionid=#{id}; expires=Fri, 17-Jan-2014 05:05:06 GMT; httponly; Max-Age=1209600; Path=/"
          session_id = value.match(/sessionid=(\S+?);/)[1]
        when 'location'
          # 'http://readlists.com/api/v1/readlists/#{id}/'
          id = value.split('/')[-1]
        end
      }
      new(id, session_id)
    end

    attr_reader :id, :session_id, :title, :description, :edit_id
    def initialize(id, session_id)
      @id = id
      @session_id = session_id
      set_edit_id
    end

    def set_edit_id
      res = request(:get)
      @edit_id = JSON.parse(res.body)['edit_id']
    end

    def url
      "http://readlists.com/#{id}/"
    end

    def entry_endpoint
      URI "#{API_ENDPOINT}#{id}/entries/"
    end

    def endpoint
      URI "#{API_ENDPOINT}#{id}/"
    end

    def title=(title)
      request(:put, "readlist_title" => title)
      @title = title
    end

    def description=(desc)
      request(:put, "description" => desc)
      @description = desc
    end

    def cookie
      "sessionid=#{session_id}"
    end

    def <<(url)
      headers = { "Cookie" => cookie }
      params = { "readlist" => DEFAULT_READLIST_PARAMS }.merge("article_url" => url)
      self.class.request(:post, entry_endpoint, params, headers)
    end
    alias_method :append, :<<

    def request(method, params = {}, headers = {})
      headers = { "Cookie" => cookie }
      params = DEFAULT_READLIST_PARAMS.merge(params)
      self.class.request(method, endpoint, params, headers)
    end
  end
end
