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
    return message if message.ascii_only?
    message.encode(Encoding::UCS_2BE).each_byte.map{ |b| (b.to_s(16).length < 2 ? '0' : '') + b.to_s(16) }.join
  end
end
