require 'message_parser'
require 'normalizer'
require 'error_codes'

module SmsSenderCbf
  require "net/http"

  include MessageParser
  include Normalizer
  include ErrorCodes

  # According to documentation: http://help.cardboardfish.com/?q=HTTPSMSSpecificationDocument
  def self.send_sms(username, password, mobile_number, sender, message)
    mobile_number_normalized = Normalizer.normalize_number(mobile_number)
    sender_normalized = Normalizer.normalize_sender(sender)
    message_normalized = Normalizer.normalize_message(message)
    http = Net::HTTP.new('sms1.cardboardfish.com', 9001)
    path = '/HTTPSMS'
    body = "S=H&UN=#{username}&P=#{password}&DA=#{mobile_number_normalized}&SA=#{sender_normalized}&M=".encode(Encoding::UCS_2BE) + message_normalized
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    response = http.get(path, body, headers)
    if response.code.to_i == 200 && MessageParser.successful_response?(response.body)
      return { message_id: MessageParser.messageid_or_error_code(response.body), code: 0 }
    else
      result = ErrorCodes.get_error_message(MessageParser.messageid_or_error_code(response.body)).merge(
        code: MessageParser.messageid_or_error_code(response.body).to_i
      )
      raise result[:error]
      return result
    end
  end
end
