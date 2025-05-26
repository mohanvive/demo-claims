import ballerina/test;
import ballerina/http;
import ballerinax/twilio;

@test:Config {}
function testSendSms() returns error? {
    http:Client testClient = check new ("http://localhost:9090/api/notification");
    SmsRequest payload = {
        message: "Test SMS",
        recipientNumber: "+1234567890"
    };

    json response = check testClient->/sms.post(payload);
    test:assertTrue(response.status == "success");
}

@test:Config {}
function testListSms() returns error? {
    http:Client testClient = check new ("http://localhost:9090/api/notification");
    twilio:Message[] response = check testClient->/sms/reply.get(fromNumber = "+0987654321");
    test:assertEquals(response.length(), 2);
}

@test:Config {}
function testInvalidPhoneNumber() returns error? {
    http:Client testClient = check new ("http://localhost:9090/api/notification");
    SmsRequest payload = {
        message: "Test SMS",
        recipientNumber: "invalid"
    };
    json|error response = testClient->/sms.post(payload);
    test:assertTrue(response is error);
}
