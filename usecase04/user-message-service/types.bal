type SmsRequest record {|
    string message;
    string recipientNumber;
|};

type ClaimData record {|
    string claimId;
    string customerPhone;
    string status;
    decimal claimAmount;
    boolean isEligible;
|};

type SmsResponse record {|
    string status;
    string message;
    string? messageId;
|};

type ReplyResponse record {|
    string? messageId;
    string status;
    string? phoneNumber;
|};
