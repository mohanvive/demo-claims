import ballerina/http;
import ballerinax/alfresco;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /documents on httpDefaultListener {

    resource function post upload(string nodeId, alfresco:NodeBodyCreate payload) returns alfresco:NodeEntry|error {
        do {
            alfresco:NodeEntry alfrescoNodeentry = check alfrescoClient->createNode(nodeId, payload);
            return alfrescoNodeentry;

        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

    resource function get download(string nodeId, boolean attachment) returns string|error? {
        do {
            string|() stringResult = check alfrescoClient->getNodeContent(nodeId);
            return stringResult;

        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }
}
