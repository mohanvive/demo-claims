import ballerinax/alfresco;

final alfresco:Client alfrescoClient = check new ({
    auth: {
        username,
        password
    }
}, serviceUrl);
