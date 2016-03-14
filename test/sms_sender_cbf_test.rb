# encoding: utf-8
require 'test_helper'

class SmsSenderCbfTest < ActiveSupport::TestCase
  test_messages = [
    'This message has been sent from automated test 😎',
    'این پیام از آزمون خودکار فرستاده شده است 😎',
    'Automated test, more ascii 😎 آزمون خودکار',
    'Automated test 😎 بیشتر غیر اسکی ،آزمون خودکار'
  ]
  if !ENV['REAL'].blank? && ENV['REAL']
    WebMock.allow_net_connect!
  else
    # Config webmock for sending messages 
    test_messages.each do |m|
      request_body_header = {:body => {'S' => 'H', 'UN' => ENV['username'], 'P' => ENV['password'], 'DA' => SmsSenderCbf::Normalizer.normalize_number(ENV['mobile_number']), 'M' => SmsSenderCbf::Normalizer.normalize_message(m)}, :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}}
      request_body_header[:body]['SA'] = ENV['sender'] if !ENV['sender'].blank?
      request_body_header[:body]['DC'] = '4' if !m.ascii_only?
      WebMock::API.stub_request(:post, 'sms1.cardboardfish.com:9001/HTTPSMS').
        with(request_body_header).
        to_return(:status => 200, 
          :body => "OK 966536430333", 
          :headers => {'Content-Type' => 'text/plain;charset=ISO-8859-1'})
    end
  end
  test 'send test' do
    test_messages.each do |m|
      send_sms_result = SmsSenderCbf.send_sms({'username' => ENV['username'], 'password' => ENV['password']}, ENV['mobile_number'], m, ENV['sender'])
      assert_not_equal send_sms_result[:message_id], nil
      assert_equal send_sms_result[:error], nil
    end
  end
end
