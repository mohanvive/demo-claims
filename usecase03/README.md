# Payment Gateway Integration

This project demonstrates the payment gateway integration with BI and stripe, including following cases.

1. Processing payment transactions
2. Refunding payment transactions
3. Testing the integration
4. Build and Test the APIs

## API Endpoints

The following REST APIs have been implemented:

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/payment/process` | Process a new payment transaction |
| POST | `/api/payment/refund` | Refund an existing payment transaction |

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

### Process Payment API

To test the `/api/payment/process` endpoint, use the following JSON payload:

```json
{
  "amount": 50,
  "currency": "usd",
  "paymentMethod": "pm_card_visa",
  "cardDetails": {
    "cardNumber": "123-4567-8910-1234",
    "expiryDate": "12/25",
    "cvv": "123"
  },
  "returnUrl": "https://sample.com"
}
```

### Refund Payment API

To test the `/api/payment/refund` endpoint, use the following JSON payload:

```json
{
  "transactionId": "pi_3RRDTq4M4ewnvM5e0PbNTWpX",
  "paymentIntentId": "pi_3RRDTq4M4ewnvM5e0PbNTWpX"
}
```

## Additional Information

- For testing purposes, Stripe provides a variety of test card numbers and tokens
- The `paymentMethod` parameter accepts standard Stripe payment method IDs
- The `returnUrl` is used for redirecting users after payment completion, particularly for payment methods requiring additional authentication
