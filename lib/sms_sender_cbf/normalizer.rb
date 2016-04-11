module SmsSenderCbf
  module Normalizer
    def self.normalize_number(number)
      n=number.dup
      while n.starts_with?('+') || n.starts_with?('0')
        n.slice!(0)
      end
      return n
    end

    def self.normalize_sender(sender)
      if sender =~ /\A\d+\Z/
        return sender.first(16)
      else
        return sender.first(11)
      end
    end

    def self.normalize_message(message)
      return message if message.ascii_only?
      message_utf16 = message.encode('UTF-16BE')
      message_encoded = message_utf16.unpack("H2"*message_utf16.bytes.count).join
      return message_encoded
    end
  end
end
