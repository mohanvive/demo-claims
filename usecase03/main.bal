import ballerina/http;
import ballerinax/stripe;
import ballerina/log;

listener http:Listener paymentListener = new(8080);

service /api/payment on paymentListener {
    resource function post process(PaymentRequest paymentRequest) returns PaymentResponse|error {
        log:printDebug("Received payment request", payload = paymentRequest);

        do {
            log:printDebug("Initiating Stripe payment intent creation...");

            stripe:Payment_intent paymentIntent = check stripeClient->/payment_intents.post({
                amount: <int>paymentRequest.amount,
                currency: paymentRequest.currency,
                description: "Payment for order",
                confirm: true,
                payment_method: paymentRequest.paymentMethod,
                return_url: paymentRequest.returnUrl
            });

            log:printDebug("Stripe payment intent created successfully", payload = paymentIntent);

            return {
                transactionId: paymentIntent.id,
                status: paymentIntent.status,
                amount: paymentIntent.amount,
                currency: paymentRequest.currency
            };
        } on fail error err {
            log:printError("Error occurred while processing payment", err);
            return error("Failed to process payment", err);
        }
    }

    resource function post refund(RefundRequest refundRequest) returns RefundResponse|error {
        do {
            stripe:Refund refund = check stripeClient->/refunds.post({
                payment_intent: refundRequest.transactionId
            });
            return {
                refundId: refund.id,
                status: refund?.status,
                refundAmount: refund.amount,
                currency: refund.currency
            };
        } on fail error err {
            return error("Failed to process refund", err);
        }
    }
}
