module ::SmsSenderCbf
  module MessageParser
    def self.successful_response?(response)
      return response.starts_with?('OK')
    end

    def self.messageid_or_error_code(response)
      status_length = response.index(' ')
      raise 'Unable to parse response: ' + response unless status_length
      response[(status_length + 1)..(response.from(status_length + 1).index(/ |\r|\n|\Z/) + status_length)]
    end
  end
end
