module SmsSenderCbf
  module ErrorCodes
    def self.get_error_message(error_code)
      # Based on http://help.cardboardfish.com/sites/default/files/HTTPSMSProtocolSpecification_V3.3_0.pdf
      case error_code
        when '-5'
          { error: 'Not Enough Credit' }
        when '-10'
          { error: 'Invalid Username Or Password' }
        when '-15'
          { error: 'Invalid Destination Or Destination Not Covered' }
        when '-20'
          { error: 'System Error, Please Retry' }
        when '-25'
          { error: 'Request Error, Do Not Retry' }
        else
          { error: 'Unknown error code' }
      end
    end

    def self.query_deliveries_status(str)
      case str.to_i
        when 1
          return 'delivered'
        when 2
          return 'buffered'
        when 3
          return 'failed'
        when 5
          return 'expired'
        when 6
          return 'rejected'
        when 7
          return 'error'
        else
          return 'unknown'
      end
    end
  end
end
