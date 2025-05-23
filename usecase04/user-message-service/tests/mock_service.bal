import ballerina/http;
import ballerinax/twilio;

service /api/notification on new http:Listener(9090) {
    resource function post sms(@http:Payload SmsRequest payload) returns json|error {
        if payload.recipientNumber == "invalid" {
            return error("Invalid phone number");
        }
        return {
            status: "success",
            message: "SMS sent successfully",
            messageId: "SM123456789"
        };
    }

    resource function get sms/reply(string fromNumber) returns twilio:Message[]|error {
        if fromNumber == "" {
            return error("From number is required");
        }

        twilio:Message[] messages = [
            {
                sid: "SM123456789",
                status: "delivered",
                'from: fromNumber,
                to: "+1234567890",
                body: "Test message 1",
                direction: "outbound-api",
                uri: "/api/messages/SM123456789"
            },
            {
                sid: "SM987654321",
                status: "delivered",
                'from: fromNumber,
                to: "+0987654321",
                body: "Test message 2",
                direction: "outbound-api",
                uri: "/api/messages/SM987654321"
            }
        ];
        return messages;
    }
}
