import ballerina/http;
import ballerinax/alfresco;

listener http:Listener mockListener = new (8081);

service /documents on mockListener {
    resource function post upload(string nodeId, alfresco:NodeBodyCreate request)
        returns alfresco:NodeEntry|error {
        if nodeId == "" {
            return error("Invalid node ID");
        }
        return {
            entry: {
                id: "123", 
                name: "test.txt", 
                nodeType: "cm:content", 
                isFolder: false, 
                isFile: false, 
                modifiedAt: "",
                modifiedByUser: {
                    id: "", 
                    displayName: ""
                },
                createdAt: "", 
                createdByUser: {
                    id: "", 
                    displayName: ""
                }
            }
        };
    }

    resource function get download(string nodeId) returns string|error {
        if nodeId == "" {
            return error("Invalid node ID");
        }
        return "Test document content";
    }
}
