import ballerina/http;
import ballerinax/twilio;

service /api/notification on new http:Listener(8080) {
    resource function post sms(@http:Payload SmsRequest payload) returns json|error {
        twilio:CreateMessageRequest messageRequest = {
            To: payload.recipientNumber,
            Body: payload.toJsonString(),
            From: payload.'from
        };

        twilio:Message response = check twilioClient->createMessage(messageRequest);
        string messageId = response?.sid ?: "";
        return {
            status: "success",
            message: "SMS sent successfully",
            messageId: messageId
        };
    }

    resource function get sms/reply(string fromNumber) returns twilio:Message[]|error? {
        twilio:ListMessageResponse twilioListmessageresponse = check twilioClient->listMessage('from = fromNumber);
        return twilioListmessageresponse.messages;
    }
}

