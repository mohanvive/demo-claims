{
  "message": "new message",
  "recipientNumber": "+94764932619",
  "claimId": "",
  "from": "+15005550006" // test number
}

{
  "message": "final message",
  "recipientNumber": "+94764932619",
  "claimId": "123",
  "from": "+17542914075" // live number
}

GET http://localhost:8080/api/notification/sms/reply?fromNumber=+94764932619
