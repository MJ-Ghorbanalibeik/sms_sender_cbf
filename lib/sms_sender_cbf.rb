require 'net/http'
require 'sms_sender_cbf/message_parser'
require 'sms_sender_cbf/normalizer'
require 'sms_sender_cbf/error_codes'

module SmsSenderCbf
  # According to documentation: http://help.cardboardfish.com/?q=HTTPSMSSpecificationDocument
  def self.send_sms(credentials, mobile_number, message, sender, options = nil)
    mobile_number_normalized = SmsSenderCbf::Normalizer.normalize_number(mobile_number)
    message_normalized = SmsSenderCbf::Normalizer.normalize_message(message)
    sender_normalized = SmsSenderCbf::Normalizer.normalize_sender(sender)
    http = Net::HTTP.new('sms1.cardboardfish.com', 9001)
    path = '/HTTPSMS'
    params = {
      'S' => 'H',
      'UN' => credentials['username'],
      'P' => credentials['password'],
      'DA' => mobile_number_normalized,
      'SA' => sender_normalized,
      'M' => message_normalized
    }
    params.merge!({ 'DC' => '4' }) unless message.ascii_only?
    body=URI.encode_www_form(params)
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    response = http.post(path, body, headers)
    if response.code.to_i == 200 && SmsSenderCbf::MessageParser.successful_response?(response.body)
      return { message_id: SmsSenderCbf::MessageParser.messageid_or_error_code(response.body), code: 0 }
    else
      result = SmsSenderCbf::ErrorCodes.get_error_message(SmsSenderCbf::MessageParser.messageid_or_error_code(response.body)).merge(
        code: SmsSenderCbf::MessageParser.messageid_or_error_code(response.body).to_i
      )
      raise result[:error]
      return result
    end
  end
end
