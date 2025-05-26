import ballerina/http;

service /api/notification on new http:Listener(9095) {
    resource function post sms(@http:Payload SmsRequest payload) returns SmsResponse|error {
        if payload.recipientNumber == "invalid" {
            return error("Invalid phone number");
        }
        return {
            status: "success",
            message: "SMS sent successfully",
            messageId: "SM123456789"
        };
    }

    resource function get sms/reply(string fromNumber) returns ReplyResponse|()|error {
        if fromNumber == "" {
            return error("From number is required");
        }
        return {
            status: "received",
            phoneNumber: fromNumber,
            messageId: "SM123456789"
        };
    }
}
