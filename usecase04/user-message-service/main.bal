import ballerina/http;
import ballerinax/twilio;
import ballerina/log;

listener http:Listener messageListener = new (8083);

service /api/notification on messageListener {
    resource function post sms(@http:Payload SmsRequest payload) returns SmsResponse|error {
        log:printInfo(string `Received message request '${payload.message}' to '${payload.recipientNumber}'`);
        twilio:CreateMessageRequest messageRequest = {
            To: payload.recipientNumber,
            Body: payload.message,
            From: "+17542914075"
        };
        twilio:Message response = check twilioClient->createMessage(messageRequest);
        return {
            status: "success",
            message: "SMS sent successfully",
            messageId: response?.sid
        };
    }

    resource function get sms/reply(string fromNumber, string expectedMessage) returns ReplyResponse|()|error {
        log:printInfo(string `Request for replies from '${fromNumber}' expecting '${expectedMessage}'`);
        twilio:ListMessageResponse twilioListmessageresponse = check twilioClient->listMessage('from = fromNumber);
        twilio:Message[]|() messages = twilioListmessageresponse.messages;
        if messages is () {
            log:printInfo(string `Received no replies from '${fromNumber}' as '${expectedMessage}'`);
            return messages;
        }
        foreach twilio:Message message in messages {
            if message?.body == expectedMessage {
                return {
                    status: "received",
                    phoneNumber: message?.'from,
                    messageId: message?.sid
                };
            }
        }
        return {
            status: "not_found",
            phoneNumber: fromNumber,
            messageId: ()
        };
    }
}

