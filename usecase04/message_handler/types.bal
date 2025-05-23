type SmsRequest record {|
    string message;
    string recipientNumber;
    string claimId;
|};

type MessageResponse record {|
    string status;
    string message;
    string? messageId;
    string? messageBody;
    string? sender;
    string? recipient;
    string? createdTime;
|};

type ClaimData record {|
    string claimId;
    string customerPhone;
    string status;
    decimal claimAmount;
    boolean isEligible;
|};
