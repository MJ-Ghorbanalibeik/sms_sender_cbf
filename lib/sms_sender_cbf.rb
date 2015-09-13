require 'message_parser'
require 'normalizer'
require 'error_codes'

module SmsSenderCbf
  require "net/http"

  include MessageParser
  include Normalizer
  include ErrorCodes

  # According to documentation: http://help.cardboardfish.com/?q=HTTPSMSSpecificationDocument
  def self.send_sms(credentials, mobile_number, message, sender, options = nil)
    mobile_number_normalized = Normalizer.normalize_number(mobile_number)
    message_normalized = Normalizer.normalize_message(message)
    sender_normalized = Normalizer.normalize_sender(sender)
    http = Net::HTTP.new('sms1.cardboardfish.com', 9001)
    path = '/HTTPSMS'
    params = {
      'S' => 'H',
      'UN' => credentials[:username],
      'P' => credentials[:password],
      'DA' => mobile_number_normalized,
      'SA' => sender_normalized,
      'M' => message_normalized
    }
    params.merge!({ 'DC' => 4 }) unless message.ascii_only?
    body=URI.encode_www_form(params)
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    response = http.post(path, body, headers)
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
