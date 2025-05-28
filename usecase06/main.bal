import ballerina/http;
import ballerina/io;
import ballerinax/alfresco;

listener http:Listener httpDefaultListener = new (8083);

service /documents on httpDefaultListener {

    resource function post upload(alfresco:NodeBodyCreate payload, string nodeId = "-root-") returns alfresco:NodeEntry|error {
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

    resource function get download/attachment(string nodeId) returns http:Response|error {
        http:Response response = new;
        
        string|() fileString = check alfrescoClient->getNodeContent(nodeId);
        byte[] fileContent = [];
        if fileString is string {
            fileContent = fileString.toBytes();
        }

        string fileName = "document.pdf";
        var nodeResponse = alfrescoClient->getNode(nodeId);
        if nodeResponse is alfresco:NodeEntry {
            fileName = nodeResponse.entry.name;
        }

        response.setHeader("Content-Type", "application/pdf");
        response.setHeader("Content-Disposition", string `attachment; filename="${fileName}"`);
        response.setBinaryPayload(fileContent);

        return response;
    }
}
