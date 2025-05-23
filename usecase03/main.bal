import ballerina/http;
import ballerinax/stripe;

listener http:Listener paymentListener = new (port = 8081);

service /api/payment on paymentListener {
    resource function post process(PaymentRequest paymentRequest) returns PaymentResponse|error {
        do {
            stripe:Payment_intent paymentIntent = check stripeClient->/payment_intents.post({
                amount: <int>paymentRequest.amount,
                currency: paymentRequest.currency,
                description: "Payment for order",
                confirm: true,
                payment_method: paymentRequest.paymentMethod,
                return_url: paymentRequest.returnUrl
            });

            return {
                transactionId: paymentIntent.id,
                status: paymentIntent.status,
                amount: paymentIntent.amount,
                currency: paymentRequest.currency
            };
        } on fail error err {
            return error("Failed to process payment", err);
        }
    }

    resource function post refund(RefundRequest refundRequest) returns RefundResponse|error {
        do {
            stripe:Refund refund = check stripeClient->/refunds.post({
                payment_intent: refundRequest.paymentIntentId
            });
            return {
                refundId: refund.id,
                status: refund?.status ?: "unknown",
                refundAmount: refund.amount,
                currency: refund.currency
            };
        } on fail error err {
            return error("Failed to process refund", err);
        }
    }
}
