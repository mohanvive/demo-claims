import ballerina/log;
import ballerinax/trigger.twilio;

listener twilio:Listener TwilioListener = new (8090);

service twilio:SmsStatusService on TwilioListener {

    remote function onAccepted(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onAccepted");
        return;
    }

    remote function onDelivered(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onDelivered");
        return;
    }

    remote function onFailed(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onFailed");
        return;
    }

    remote function onQueued(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onQueued");
        return;
    }

    remote function onReceived(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onReceived");
        _ = check handleSmsRequest(<string>event.Body, <string>event.From);
        return;
    }

    remote function onReceiving(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onReceiving");
        return;
    }

    remote function onSending(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onSending");
        return;
    }

    remote function onSent(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onSent");
        return;
    }

    remote function onUndelivered(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onUndelivered");
        return;
    }
}
