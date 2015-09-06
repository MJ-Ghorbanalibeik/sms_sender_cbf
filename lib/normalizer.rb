module Normalizer
  def self.normalize_number(n)
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
    message.encode(Encoding::UCS_2BE)
  end
end
