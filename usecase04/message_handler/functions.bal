import ballerinax/twilio;
import ballerina/io;

function handleSmsRequest(string body, string fromNumber) returns error? {
    twilio:CreateMessageRequest messageRequest = {
        To: fromNumber,
        Body: "claim approved",
        From: "+17542914075"
    };
    _ = check twilioClient->createMessage(messageRequest);
    io:println("Message received: ", body);
}
