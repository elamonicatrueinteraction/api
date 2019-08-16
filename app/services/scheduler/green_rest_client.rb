require 'net/http'

module Scheduler
  class GreenRestClient
    def self.call(url, verb, data, response_parse_proc)
      begin
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = false
        http.read_timeout = 300000

        http.set_debug_output $stderr

        case verb
          when 'POST'
            request = Net::HTTP::Post.new(uri.to_s, {'Content-Type' =>'application/json'})
          when 'GET'
            request = Net::HTTP::Get.new(uri.to_s, {'Content-Type' =>'application/json'})
          when 'PUT'
            request = Net::HTTP::Put.new(uri.to_s, {'Content-Type' =>'application/json'})
          when 'DELETE'
            request = Net::HTTP::Delete.new(uri.to_s, {'Content-Type' =>'application/json'})
          else
            throw WebServiceFaultException.new('El parametro verb no tiene un valor valido')
        end

        request.body = data.to_json

        response = http.request(request)

        if response.code != '200'
          error = [
            "http code: #{response.code}",
            "http message: #{response.message}",
            "http body: #{response.body}"
          ]

          raise WebServiceFaultException.new("Se produjo un error al realizar el request: Detalle: \n #{error.to_s}")
        end

        if response_parse_proc
          result = response_parse_proc.call(response.body)
        else
          result = JSON.parse(response.body)
        end

        return result
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::ECONNREFUSED, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        puts $!.backtrace
        exception = WebServiceFaultException.new('Error de conexion')
        exception.inner_exception = e
        puts '*' * 100
        p e
        raise exception
      rescue SocketError
        exception = WebServiceFaultException.new('Error de conexion')
        exception.inner_exception = e
        puts '*' * 100
        p e
        raise exception
      end
    end
  end
end