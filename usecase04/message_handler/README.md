# Message Handler

This project demonstrates the Twilio event trigger integration with Ballerina, including the following cases:

1. Listening to Twilio SMS status change events
2. Handling incoming message events
3. Processing message status callbacks
4. Automated response handling

## Overview

This is to demonstrate Twilio event trigger which allows you to listen to Twilio SMS and call status change events similar to a situation where incoming message events and message status change callback events from Twilio SMS.

## Prerequisites

Before using this trigger in your Ballerina application, complete the following:

### Setting up Twilio Account

* Sign up to Twilio and create a Twilio account. For step-by-step instructions, see [View and Create New Accounts in Twilio](https://support.twilio.com/hc/en-us/articles/360011177133-View-and-Create-New-Accounts-in-Twilio-Console).

### Purchase Twilio Phone Number

Follow the steps below to purchase a Twilio phone number to send messages and make phone calls using Twilio:

1. Go to **Phone Numbers -> Manage** on the left navigation pane under the **Develop** section.
2. Click **Buy a Number** and proceed to purchase.

### Configure Forwarding URL

Get the **Forwarding URL**. Use the deployed endpoint link on devant as **Forwarding URL** or if you are trying this locally try the following:

1. Run the following command to start ngrok on the same port.

   ```bash
   ngrok http 8090
   ```

2. Copy the **Forwarding URL** displayed in your terminal. You need this URL to configure **TwilioML SMS**.

### Configure TwilioML Calls

Follow the steps below to configure TwilioML calls:

1. Go to **Phone Numbers -> Manage -> Active Numbers.**
2. Click on your number
3. Scroll to the **Voice & Fax** section, and paste the **Forwarding URL** you copied via ngrok under **A CALL COMES IN.**
4. Select **WEBHOOK** as the type and **HTTP POST** as the protocol
5. Click **Save**

### Configure TwilioML SMS

Follow the steps below to configure TwilioML SMS:

1. Go to **Messaging -> Services.**
2. Click **Create a messaging service** to set up a messaging service.
3. Enter an appropriate name for the messaging service.
4. Add senders to the messaging service.
5. In the **Set up integration** step, under **Incoming Messages**, select **Send a webhook**.
6. Paste the **Forwarding URL** you copied via ngrok as the **Request URL**.
7. Proceed with the next steps and click **Complete Messaging Service Setup**.

## Getting Started

### Running the Project

You can run the Ballerina project directly using the run button in your IDE. The Twilio listener will start on port 8090.

### Running Tests

Test cases are located in the `tests` directory and can be executed with:

```bash
bal test
```

## Testing the Integration

Start the Twilio trigger and try sending a message to your number. The `onReceived` function will trigger and it will send an automated response message.

### Event Handlers

The following SMS status change events are handled:

| Event Handler | Description |
|---------------|-------------|
| `onAccepted` | Triggered when SMS is accepted by Twilio |
| `onDelivered` | Triggered when SMS is successfully delivered |
| `onFailed` | Triggered when SMS delivery fails |
| `onQueued` | Triggered when SMS is queued for sending |
| `onReceived` | Triggered when SMS is received (incoming message) |
| `onReceiving` | Triggered when SMS is being received |
| `onSending` | Triggered when SMS is being sent |
| `onSent` | Triggered when SMS is sent successfully |
| `onUndelivered` | Triggered when SMS cannot be delivered |

### Code Implementation

The main service implementation includes:

```ballerina
import ballerina/log;
import ballerinax/trigger.twilio;

listener twilio:Listener TwilioListener = new (8090);

service twilio:SmsStatusService on TwilioListener {
    remote function onReceived(twilio:SmsStatusChangeEventWrapper event) returns error? {
        log:printInfo("Triggered onReceived");
        _ = check handleSmsRequest(<string>event.Body, <string>event.From);
        return;
    }
    // ... other event handlers
}
```

### Automated Response Handler

The system automatically responds to incoming messages with "claim approved":

```ballerina
function handleSmsRequest(string body, string fromNumber) returns error? {
    twilio:CreateMessageRequest messageRequest = {
        To: fromNumber,
        Body: "claim approved",
        From: phoneNumber
    };
    _ = check twilioClient->createMessage(messageRequest);
    io:println("Message received: ", body);
}
```

## Additional Information

- Ensure your Twilio account has sufficient credits for sending messages
- The webhook URL must be accessible from the internet (use ngrok for local development)
- All incoming messages will automatically receive a "claim approved" response
- Monitor the logs to see which event handlers are being triggered
- The listener runs on port 8090 by default
