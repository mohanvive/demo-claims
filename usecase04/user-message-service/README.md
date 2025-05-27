# User Message Service

This project demonstrates the messaging service integration with BI and Twilio, including following cases.

1. Sending SMS notifications
2. Receiving SMS replies
3. Testing the integration
4. Build and Test the APIs

## API Endpoints

The following REST APIs have been implemented:

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/notification/sms` | Send SMS notification to recipient |
| GET | `/api/notification/sms/reply` | Receive and check SMS replies |

## Getting Started

### Running the Project

You can run the BI project directly using the run button in your IDE and use the `Try It` feature to test the APIs.

### Running Tests

Test cases are located in the `tests` directory and can be executed with:

```bash
bal test
```

## Testing the APIs

Use the `Try It` feature to test each API.

### Send SMS API

To test the `/api/notification/sms` endpoint, use the following JSON payload:

```http
POST /api/notification/sms

{
  "message": "Hello, this is a test message.",
  "recipientNumber": "add-mobile-number"
}
```

**Response:**

```json
{
  "status": "success",
  "message": "SMS sent successfully",
  "messageId": "SM0fd071cda5112f64e9e1eb17da36a476"
}
```

### SMS Reply API

To test the `/api/notification/sms/reply` endpoint, use the following query parameters:

```http
GET /api/notification/sms/reply?fromNumber=<add-mobile-number>&expectedMessage=<add-expected-message>
```

**Response:**

```json
{
  "messageId": "SM0f0f94cbec35d66b5699e418e15b2beb",
  "status": "received",
  "phoneNumber": "add-mobile-number"
}
```

## Additional Information

- For testing purposes, Twilio provides test phone numbers and sandbox environments
- The `recipientNumber` parameter must be a valid phone number in international format (e.g., +94764932619)
- The `expectedMessage` parameter is used to filter and check for specific reply messages
- Message IDs are unique identifiers provided by Twilio for tracking SMS delivery and status
