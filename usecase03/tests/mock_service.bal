import ballerina/http;

service /api/payment on new http:Listener(9090) {
    resource function post process(PaymentRequest request) returns PaymentResponse|error {
        int amount = <int>request.amount;
        if amount <= 0 {
            return error("Invalid amount");
        }
        return {
            status: "succeeded",
            amount: amount,
            currency: request.currency,
            transactionId: "mockId"
        };
    }

    resource function post refund(RefundRequest request) returns RefundResponse|error {
        string paymentIntentId = request.transactionId;

        if paymentIntentId != "mockId" {
            return error("Invalid payment intent ID");
        }

        return {
            status: "succeeded",
            refundId: "mockRefundId",
            refundAmount: 100,
            currency: "USD"
        };
    }
}
