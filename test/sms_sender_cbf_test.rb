require 'test_helper'

class SmsSenderCbfTest < ActiveSupport::TestCase
  test 'truth' do
    assert_kind_of Module, SmsSenderCbf
  end

  test 'send test' do
    send_sms_result = SmsSenderCbf.send_sms({username: ENV['username'], password: ENV['password']}, ENV['mobile_number'], 'This message has been sent from automated test', ENV['sender'])
    assert_not_equal send_sms_result[:message_id], nil
    assert_equal send_sms_result[:error], nil
  end

  test 'send test unicode' do
    send_sms_result = SmsSenderCbf.send_sms({username: ENV['username'], password: ENV['password']}, ENV['mobile_number'], 'این متن از آزمون خودکار فرستاده شده', ENV['sender'])
    assert_not_equal send_sms_result[:message_id], nil
    assert_equal send_sms_result[:error], nil
  end
end
