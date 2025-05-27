import ballerina/http;
import ballerina/test;

@test:Config {}
function testUploadDocument() returns error? {
    http:Client testClient = check new ("http://localhost:8081");
    json payload = {
        "name": "test.txt",
        "nodeType": "cm:content",
        "properties": {
            "cm:title": "Test Document"
        }
    };

    json response = check testClient->/documents/upload.post(
        nodeId = "123",
        message = payload
    );
    test:assertEquals(response.entry.name, "test.txt");
    test:assertEquals(response.entry.nodeType, "cm:content");
}

@test:Config {}
function testUploadDocumentError() returns error? {
    http:Client testClient = check new ("http://localhost:8081");
    json payload = {
        "name": "test.txt",
        "nodeType": "cm:content"
    };

    json|error response = testClient->/documents/upload.post(
        nodeId = "",
        message = payload
    );
    test:assertTrue(response is error);
}

@test:Config {}
function testDownloadDocument() returns error? {
    http:Client testClient = check new ("http://localhost:8081");
    string response = check testClient->/documents/download.get(
        nodeId = "testNode123"
    );
    test:assertEquals(response, "Test document content");
}

@test:Config {}
function testDownloadDocumentError() returns error? {
    http:Client testClient = check new ("http://localhost:8081");
    string|error response = testClient->/documents/download.get(
        nodeId = ""
    );
    test:assertTrue(response is error);
}
