import ballerina/http;
import ballerina/test;

final http:Client testClient = check new ("http://localhost:9099/api/payment");

@test:Config {}
function testSuccessfulPayment() returns error? {
    PaymentRequest paymentRequest = {
        amount: 100.0,
        currency: "USD",
        paymentMethod: "pm_card_visa",
        returnUrl: "https://example.com/return"
    };

    PaymentResponse response = check testClient->/process.post(paymentRequest);
    test:assertEquals(response.status, "succeeded");
}

@test:Config {}
function testInvalidPaymentAmount() returns error? {
    PaymentRequest paymentRequest = {
        amount: -100.0,
        currency: "USD",
        paymentMethod: "pm_card_visa",
        returnUrl: "https://example.com/return"
    };

    PaymentResponse|error response = testClient->/process.post(paymentRequest);
    test:assertTrue(response is error);
}

@test:Config {}
function testSuccessfulRefund() returns error? {
    RefundRequest refundRequest = {
        transactionId: "id",
        paymentIntentId: "mockId"
    };

    RefundResponse response = check testClient->/refund.post(refundRequest);
    test:assertEquals(response.status, "succeeded");
}

@test:Config {}
function testInvalidRefund() returns error? {
    RefundRequest refundRequest = {
        transactionId: "tx_123",
        paymentIntentId: "pi_invalid"
    };

    RefundResponse|error response = testClient->/refund.post(refundRequest);
    test:assertTrue(response is error);
}
