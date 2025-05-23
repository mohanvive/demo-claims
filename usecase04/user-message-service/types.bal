type SmsRequest record {|
    string message;
    string recipientNumber;
    string claimId;
    string 'from;
|};

type ClaimData record {|
    string claimId;
    string customerPhone;
    string status;
    decimal claimAmount;
    boolean isEligible;
|};
