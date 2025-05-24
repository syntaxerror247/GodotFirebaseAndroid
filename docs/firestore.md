# Cloud Firestore

The Cloud Firestore module in **GodotFirebaseAndroid** supports adding, retrieving, updating, and deleting documents, as well as listening for document changes.

## Signals

-`write_task_completed(result: Dictionary)`
  Emitted after adding or setting a document.

-`get_task_completed(result: Dictionary)`
  Emitted after retrieving a document or a list of documents.

-`update_task_completed(result: Dictionary)`
  Emitted after updating a document.

-`delete_task_completed(result: Dictionary)`
  Emitted after deleting a document.

-`document_changed(document_path: String, data: Dictionary)`
  Emitted when a listened document is changed.

**Note**: All signal result dictionaries contain the following keys:

- status (bool): true if the operation succeeded, false otherwise.

- docID (String): The Firestore document ID related to the operation.

- data (optional Dictionary): The data returned in the operation (if applicable).

- error (optional String): The error message if the operation failed.

## Methods

### `add_document(collection: String, data: Dictionary)`

Adds a new document to the specified collection with an auto-generated ID.
**Emits:** `write_task_completed`

```gdscript
Firebase.firestore.add_document("players", {"name": "Alice", "score": 100})
```

---

### `set_document(collection: String, documentId: String, data: Dictionary, merge: bool = false)`

Sets data for a document. If the document exists, it will be overwritten unless `merge` is `true`.
**Emits:** `write_task_completed`

```gdscript
Firebase.firestore.set_document("players", "user_123", {"score": 150}, true)
```

---

### `get_document(collection: String, documentId: String)`

Retrieves a single document from the specified collection.
**Emits:** `get_task_completed`

```gdscript
Firebase.firestore.get_document("players", "user_123")
```

---

### `get_documents_in_collection(collection: String)`

Retrieves all documents in a given collection.
**Emits:** `get_task_completed`

```gdscript
Firebase.firestore.get_documents_in_collection("players")
```

---

### `update_document(collection: String, documentId: String, data: Dictionary)`

Updates fields in a document without overwriting the entire document.
**Emits:** `update_task_completed`

```gdscript
Firebase.firestore.update_document("players", "user_123", {"score": 200})
```

---

### `delete_document(collection: String, documentId: String)`

Deletes a document from the specified collection.
**Emits:** `delete_task_completed`

```gdscript
Firebase.firestore.delete_document("players", "user_123")
```

---

### `listen_to_document(documentPath: String)`

Starts listening to changes on a specific document path.
**Emits:** `document_changed`

```gdscript
Firebase.firestore.listen_to_document("players/user_123")
```

---

### `stop_listening_to_document(documentPath: String)`

Stops listening to changes for a document path.

```gdscript
Firebase.firestore.stop_listening_to_document("players/user_123")
```

---
