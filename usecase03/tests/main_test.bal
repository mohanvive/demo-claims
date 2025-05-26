import ballerina/http;
import ballerina/test;

final http:Client testClient = check new ("http://localhost:9090");

@test:Config {}
function testSuccessfulPayment() returns error? {
    PaymentRequest paymentRequest = {
        amount: 100.0,
        currency: "USD",
        paymentMethod: "pm_card_visa",
        returnUrl: "https://example.com/return"
    };

    PaymentResponse response = check testClient->/api/payment/process.post(paymentRequest);
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

    PaymentResponse|error response = testClient->/api/payment/process.post(paymentRequest);
    test:assertTrue(response is error);
}

@test:Config {}
function testSuccessfulRefund() returns error? {
    RefundRequest refundRequest = {
        transactionId: "mockId",
        refundAmount: 50.00
    };

    RefundResponse response = check testClient->/api/payment/refund.post(refundRequest);
    test:assertEquals(response.status, "succeeded");
}

@test:Config {}
function testInvalidRefund() returns error? {
    RefundRequest refundRequest = {
        transactionId: "pi_invalid",
        refundAmount: 5.00
    };

    RefundResponse|error response = testClient->/api/payment/refund.post(refundRequest);
    test:assertTrue(response is error);
}
