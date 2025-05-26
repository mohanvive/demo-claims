import ballerina/http;
import ballerinax/twilio;

listener http:Listener messageListener = http:getDefaultListener();

service /api/notification on messageListener {
    resource function post sms(@http:Payload SmsRequest payload) returns SmsResponse|error {
        twilio:CreateMessageRequest messageRequest = {
            To: payload.recipientNumber,
            Body: payload.toJsonString(),
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
        twilio:ListMessageResponse twilioListmessageresponse = check twilioClient->listMessage('from = fromNumber);
        twilio:Message[]|() messages = twilioListmessageresponse.messages;
        if messages is () {
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

