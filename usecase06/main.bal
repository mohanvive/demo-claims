import ballerina/http;
import ballerina/io;
import ballerinax/alfresco;

listener http:Listener httpDefaultListener = new (8083);

service /documents on httpDefaultListener {

    resource function post upload(string nodeId, alfresco:NodeBodyCreate payload) returns alfresco:NodeEntry|error {
        do {
            alfresco:NodeEntry alfrescoNodeentry = check alfrescoClient->createNode(nodeId, payload);
            byte[] content = check io:fileReadBytes("resources/hello.txt");
            alfresco:NodeEntry alfrescoNodeentryResult = check alfrescoClient->updateNodeContent(alfrescoNodeentry.entry.id, content);
            return alfrescoNodeentryResult;

        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

    resource function get download(string nodeId) returns string|error? {
        do {
            string|() stringResult = check alfrescoClient->getNodeContent(nodeId);
            return stringResult;

        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }
}
