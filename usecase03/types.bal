
type PaymentRequest record {|
    decimal amount;
    string currency;
    string paymentMethod;
    CardDetails cardDetails?;
    string returnUrl;
|};

type CardDetails record {|
    string cardNumber;
    string expiryDate;
    string cvv;
|};

type PaymentResponse record {|
    string transactionId;
    string status;
    int amount;
    string currency;
|};

type RefundRequest record {|
    string transactionId;
    string paymentIntentId;
|};

type RefundResponse record {|
    string refundId;
    string status;
    int refundAmount;
    string currency;
|};
