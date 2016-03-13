# SMS sender cbf

[![Circle CI](https://circleci.com/gh/MJ-Ghorbanalibeik/sms_sender_cbf/tree/master.svg?style=svg)](https://circleci.com/gh/MJ-Ghorbanalibeik/sms_sender_cbf/tree/master)

rails gem to send sms via http://sms2.cardboardfish.com:9001/HTTPSMS

http api based on: 
http://help.cardboardfish.com/sites/default/files/HTTPSMSProtocolSpecification_V3.3_0.pdf

Version log:
  1.2.0: 
    Add webmock for test (use ```dotenv rake test REAL=true``` to make real requests instead of stubed ones). 
    Use string in hash parameters instead of symbol.
