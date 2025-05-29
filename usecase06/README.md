# Content Management with Alfresco

This project demonstrates the Alfresco integration to manage contents. The implementation includes functionality for uploading and downloading files within the Alfresco content repository.

## Features

- Upload files to Alfresco
- Download files as string content
- Download files as attachments

## API Endpoints

### Upload File

Upload a file to the Alfresco repository.

**Endpoint:** `POST /upload`

**Content-Type:** `multipart/form-data`

**Parameters:**

| Parameter | Type | Content-Type | Description |
|-----------|------|--------------|-------------|
| `file` | File | `application/octet-stream` | The file to be uploaded |
| `nodeId` | Text | `text/plain` | Target node ID in Alfresco repository |
| `name` | Text | `text/plain` | Name for the uploaded file |

**Example Request:**

```bash
curl -X POST http://localhost:8080/upload \
  -F "file=@/path/to/your/file.pdf" \
  -F "nodeId=workspace://SpacesStore/12345" \
  -F "name=document.pdf"
```

### Download file as string

Retrieve file content as a string response.

**Endpoint:** `GET /download`

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `nodeId` | string | Unique identifier of the file node |

**Example Request:**

```bash
GET /download?nodeId=123
```

**Response:** File content returned as string data

### Download file as attachment

Download file as an attachment with proper headers for file download.

**Endpoint:** `GET /download/attachment`

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `nodeId` | string | Unique identifier of the file node |

**Example Request:**

```bash
GET /download/attachment?nodeId=7b7db021-6004-45b3-bdb0-21600455b3d1
```

**Response:** File download with `Content-Disposition: attachment` header

## Notes

- Ensure proper authentication is configured for Alfresco repository access
- Node IDs should be valid Alfresco node references
- File uploads support various content types through `application/octet-stream`
- Downloaded attachments will include original filename when available
