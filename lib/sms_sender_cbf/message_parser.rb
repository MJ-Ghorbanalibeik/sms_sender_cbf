module SmsSenderCbf
  module MessageParser
    def self.successful_response?(response)
      return response.starts_with?('OK')
    end

    def self.messageid_or_error_code(response)
      status_length = response.index(' ')
      raise 'Unable to parse response: ' + response unless status_length
      response[(status_length + 1)..(response.from(status_length + 1).index(/ |\r|\n|\Z/) + status_length)]
    end

    def self.query_deliveries_succesful_response?(response)
      return true if response.index('#') 
      return false
    end

    def self.query_deliveries_parser(response)
      response_count = response[0..(response.index('#')-1)].to_i
      deliveries = response[(response.index('#')+1)..(response.index('-1') ? response.index('-1') : response.length)].split(':')
      result_collection = []
      response_count.times do |index|
        result_item = {}
        result_item['message_id'] = deliveries[index*7 + 0]
        result_item['source'] = deliveries[index*7 + 1]
        result_item['destination'] = deliveries[index*7 + 2]
        result_item['status'] = SmsSenderCbf::ErrorCodes.query_deliveries_status(deliveries[index*7 + 3])
        result_item['error_code'] = deliveries[index*7 + 4]
        result_item['date_time'] = deliveries[index*7 + 5]
        result_item['user_ref'] = deliveries[index*7 + 6]
        result_collection.append(result_item)
      end
      return result_collection
    end
  end
end
