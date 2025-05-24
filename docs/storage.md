---
layout: default
title: Cloud Storage
nav_order: 5
---

# Cloud Storage

The Cloud Storage module in **GodotFirebaseAndroid** provides methods to upload, download, delete, and list files from Firebase Cloud Storage. Each method emits signals to indicate the outcome of the operation.

## Signals

- `upload_task_completed(result: Dictionary)`
  Emitted when a file upload completes. The result contains metadata or error information.

- `download_task_completed(result: Dictionary)`
  Emitted when a file download completes. The result contains file information or error details.

- `delete_task_completed(result: Dictionary)`
  Emitted when a file is deleted. The result indicates success or failure.

- `list_task_completed(result: Dictionary)`
  Emitted when files are listed in a directory. The result includes a list of files or error information.

## Methods

{: .text-green-100 }
### upload_file(path: String, localFilePath: String)

Uploads a file from the local file system to the specified path in Firebase Storage.

**Emits:** `upload_task_completed`

```gdscript
Firebase.storage.upload_file("uploads/image.png", "user://images/image.png")
```

---

{: .text-green-100 }
### download_file(path: String, destinationPath: String)

Downloads a file from Firebase Storage to the specified local path.

**Emits:** `download_task_completed`

```gdscript
Firebase.storage.download_file("uploads/image.png", "user://downloads/image.png")
```

---

{: .text-green-100 }
### get_metadata(path: String)

Retrieves metadata for the specified file in Firebase Storage.

**Emits:** `download_task_completed`

```gdscript
Firebase.storage.get_metadata("uploads/image.png")
```

---

{: .text-green-100 }
### delete_file(path: String)

Deletes a file from Firebase Storage.

**Emits:** `delete_task_completed`

```gdscript
Firebase.storage.delete_file("uploads/old_image.png")
```

---

{: .text-green-100 }
### list_files(path: String)

Lists files in the given directory in Firebase Storage.

**Emits:** `list_task_completed`

```gdscript
Firebase.storage.list_files("uploads")
```
