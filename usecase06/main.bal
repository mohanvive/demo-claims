import ballerina/http;
import ballerinax/alfresco;
import ballerina/mime;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /documents on httpDefaultListener {
    resource function post upload(http:Request request) returns CustomNodeEntry|error {
        mime:Entity[] bodyParts = check request.getBodyParts();
        mime:Entity filePart = bodyParts[0];
        byte[] fileContent = check filePart.getByteArray();

        string nodeId = "";
        string name = "";
        foreach mime:Entity part in bodyParts {
            mime:ContentDisposition disposition = part.getContentDisposition();
            if disposition is mime:ContentDisposition {
                if disposition.name == "nodeId" {
                    nodeId = check part.getText();
                } else if disposition.name == "name" {
                    name = check part.getText();
                }
            }
        }

        alfresco:NodeBodyCreate payload = {
            name: name,
            nodeType: "cm:content",
            aspectNames: ["cm:titled"],
            properties: {
                "cm:title": name
            }
        };

        alfresco:NodeEntry createdNode = check alfrescoClient->createNode(nodeId, payload);
        alfresco:NodeEntry alfrescoNodeEntryResult = check alfrescoClient->updateNodeContent(createdNode.entry.id, fileContent);

        return {
            id: alfrescoNodeEntryResult.entry.id,
            name: alfrescoNodeEntryResult.entry.name,
            createdByUser: {
                id: alfrescoNodeEntryResult.entry.createdByUser.id,
                displayName: alfrescoNodeEntryResult.entry.createdByUser.displayName
            }
        };
    }

    resource function get download(string nodeId) returns string|error? {
        do {
            byte[]|() result = check alfrescoClient->getNodeContent(nodeId);
            if result is () {
                return error("No content found for nodeId");
            }
            return string:fromBytes(result);

        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

    resource function get download/attachment(string nodeId) returns http:Response|error {
        http:Response response = new;
        
        byte[]|() fileContent = check alfrescoClient->getNodeContent(nodeId);
        if fileContent is () {
            return error("No content found for nodeId");
        }

        alfresco:NodeEntry nodeResponse = check alfrescoClient->getNode(nodeId);
        string fileName = nodeResponse.entry.name;

        response.setHeader("Content-Type", "application/pdf");
        response.setHeader("Content-Disposition", string `attachment; filename="${fileName}"`);
        response.setBinaryPayload(fileContent);

        return response;
    }
}
