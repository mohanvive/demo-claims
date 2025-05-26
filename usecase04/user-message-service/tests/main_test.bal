import ballerina/test;
import ballerina/http;

@test:Config {}
function testSendSms() returns error? {
    http:Client testClient = check new ("http://localhost:9095/api/notification");
    SmsRequest payload = {
        message: "Test SMS",
        recipientNumber: "+1234567890"
    };

    SmsResponse response = check testClient->/sms.post(payload);
    test:assertTrue(response.status == "success");
}

@test:Config {}
function testListSms() returns error? {
    http:Client testClient = check new ("http://localhost:9095/api/notification");
    ReplyResponse response = check testClient->/sms/reply.get(fromNumber = "+1234567890");
    test:assertEquals(response.status, "received");
}

@test:Config {}
function testInvalidPhoneNumber() returns error? {
    http:Client testClient = check new ("http://localhost:9095/api/notification");
    SmsRequest payload = {
        message: "Test SMS",
        recipientNumber: "invalid"
    };
    SmsResponse|error response = testClient->/sms.post(payload);
    test:assertTrue(response is error);
}
