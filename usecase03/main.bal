import ballerina/http;
import ballerinax/stripe;
import ballerina/log;

listener http:Listener paymentListener = new(8080);

service /api/payment on paymentListener {
    resource function post process(PaymentRequest paymentRequest) returns PaymentResponse|error {
        log:printInfo("Received payment request", payload = paymentRequest);

        do {
            log:printInfo("Initiating Stripe payment intent creation...");

            stripe:Payment_intent paymentIntent = check stripeClient->/payment_intents.post({
                amount: <int>(paymentRequest.amount * 100),
                currency: paymentRequest.currency,
                description: "Payment for order",
                confirm: true,
                payment_method: paymentRequest.paymentMethod,
                return_url: paymentRequest.returnUrl
            });

            log:printInfo("Stripe payment intent created successfully", payload = paymentIntent);

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
        log:printInfo("Received refund request", payload = refundRequest);
        do {
            stripe:Refund refund = check stripeClient->/refunds.post({
                payment_intent: refundRequest.transactionId
            });
            log:printInfo("Refund created successfully", payload = refund);
            return {
                refundId: refund.id,
                status: refund?.status,
                refundAmount: refund.amount,
                currency: refund.currency
            };
        } on fail error err {
            log:printError("Error occurred while processing payment", err);
            return error("Failed to process refund", err);
        }
    }
}
