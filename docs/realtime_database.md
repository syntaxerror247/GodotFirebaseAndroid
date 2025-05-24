---
layout: default
title: Realtime Database
nav_order: 4
---

# Realtime Database

The Realtime Database module in **GodotFirebaseAndroid** supports reading, writing, and listening to changes in the Firebase Realtime Database.

## Signals

- `write_task_completed(result: Dictionary)`
  Emitted after a write (set) operation completes. The dictionary contains a `success` boolean and optionally a `message`.

- `get_task_completed(result: Dictionary)`
  Emitted after a get (read) operation completes. Contains either the fetched data or an error.

- `update_task_completed(result: Dictionary)`
  Emitted after an update operation. Indicates success or failure.

- `delete_task_completed(result: Dictionary)`
  Emitted after a delete operation. Indicates success or failure.

- `db_value_changed(path: String, data: Dictionary)`
  Emitted when a value at a listened path changes.

**Note**: All signal result dictionaries contain the following keys:

- status (bool): true if the operation succeeded, false otherwise.

- path (String): The Realtime Database path related to the operation.

- data (optional Dictionary): The data returned in the operation (if applicable).

- error (optional String): The error message if the operation failed.

## Methods

{: .text-green-100 }
### set_value(path: String, data: Dictionary)

Sets data at the specified path.

**Emits:** `write_task_completed`.

```gdscript
Firebase.realtimeDB.set_value("/users/user1", {"name": "Alice", "score": 10})
```

---

{: .text-green-100 }
### get_value(path: String)

Retrieves data from the specified path.

**Emits:** `get_task_completed`.

```gdscript
Firebase.realtimeDB.get_value("/users/user1")
```

---

{: .text-green-100 }
### update_value(path: String, data: Dictionary)

Updates specific fields at the given path.

**Emits:** `update_task_completed`.

```gdscript
Firebase.realtimeDB.update_value("/users/user1", {"score": 15})
```

---

{: .text-green-100 }
### delete_value(path: String)

Deletes data at the given path.

**Emits:** `delete_task_completed`.

```gdscript
Firebase.realtimeDB.delete_value("/users/user1")
```

---

{: .text-green-100 }
### listen_to_path(path: String)

Listens to realtime changes at the specified path.

**Emits:** `db_value_changed` on every update.

```gdscript
Firebase.realtimeDB.listen_to_path("/users/user1")
```

---

{: .text-green-100 }
### stop_listening(path: String)

Stops listening for changes at the specified path.

```gdscript
Firebase.realtimeDB.stop_listening("/users/user1")
```
