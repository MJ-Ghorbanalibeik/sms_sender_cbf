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
      # In order to overcome emoji problem in unicode messages, i've guessed 
      # that service provider compares amount of ucs-2 with ucs-4 characters,
      # to determine which encoding should it use.
      byte_map = ''
      emoji_covered = false
      number_of_non_ascii = message.each_char.map{|c| c.ascii_only? ? 1 : 0 }.sum
      message.encode(Encoding::UCS_2BE).each_char do |char|
        if char.bytes[0].to_s(16) == 'd8' && char.bytes[1].to_s(16) == '3d'
          byte_map += 'feff' * (message.length - number_of_non_ascii) if !emoji_covered
          byte_map += char.each_byte.map{ |b| (b.to_s(16).length < 2 ? '0' : '') + b.to_s(16) }.join
          byte_map += 'feff' if !emoji_covered
          emoji_spoted = true
        else
          byte_map += char.each_byte.map{ |b| (b.to_s(16).length < 2 ? '0' : '') + b.to_s(16) }.join
        end
      end
      return byte_map
    end
  end
end