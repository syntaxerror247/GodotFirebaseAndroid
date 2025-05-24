---
layout: default
title: Authentication
nav_order: 2
---

# Authentication

The Firebase Authentication module in **GodotFirebaseAndroid** supports anonymous login, email/password login, Google login, and account management. Each method emits signals to indicate success or failure.

## Signals

- `auth_success(current_user_data: Dictionary)`
  Emitted when a user successfully signs in. The dictionary contains user information such as UID, email, etc.

- `auth_failure(error_message: String)`
  Emitted when an authentication operation fails.

- `sign_out_success(success: bool)`
  Emitted after a sign-out operation. `true` indicates success.

- `password_reset_sent(success: bool)`
  Emitted after attempting to send a password reset email.

- `email_verification_sent(success: bool)`
  Emitted after attempting to send an email verification email.

- `user_deleted(success: bool)`
  Emitted after an attempt to delete the current user.

## Methods

{: .text-green-100 }
### sign_in_anonymously()

Signs in the user anonymously.

**Emits:** `auth_success` or `auth_failure`.

```gdscript
Firebase.auth.sign_in_anonymously()
```

---

{: .text-green-100 }
### create_user_with_email_password(email: String, password: String)

Creates a new user with the given email and password.

**Emits:** `auth_success` or `auth_failure`.

```gdscript
Firebase.auth.create_user_with_email_password("testuser@email.com", "password123")
```

---

{: .text-green-100 }
### sign_in_with_email_password(email: String, password: String)

Signs in a user using email and password credentials.

**Emits:** `auth_success` or `auth_failure`.

```gdscript
Firebase.auth.sign_in_with_email_password("testuser@email.com", "password123")
```
---

{: .text-green-100 }
### send_password_reset_email(email: String)

Sends a password reset email to the specified address.

**Emits:** `password_reset_sent`. It also emits `auth_failure` on failure.

```gdscript
Firebase.auth.send_password_reset_email("testuser@email.com")
```
---

{: .text-green-100 }
### send_email_verification()

Sends an email verification to the currently signed-in user.

**Emits:** `email_verification_sent`. It also emits `auth_failure` on failure.

```gdscript
Firebase.auth.send_email_verification()
```
---

{: .text-green-100 }
### sign_in_with_google()

Signs in the user using Google. Ensure Google Sign-In is properly configured in the Firebase console.

**Emits:** `auth_success` or `auth_failure`.

```gdscript
Firebase.auth.sign_in_with_google()
```
---

{: .text-green-100 }
### get_current_user_data() -> Dictionary

If no user is signed in, returns an dictionary with error.

**Returns** a dictionary containing the currently signed-in user's data.

```gdscript
Firebase.auth.get_current_user_data()
```
---

{: .text-green-100 }
### delete_current_user()

Deletes the currently signed-in user.

**Emits:** `user_deleted`. It also emits `auth_failure` on failure.

```gdscript
Firebase.auth.delete_current_user()
```
---

{: .text-green-100 }
### is_signed_in() -> bool

**Returns** `true` if a user is currently signed in, otherwise `false`.

```gdscript
Firebase.auth.is_signed_in()
```
---

{: .text-green-100 }
### sign_out()

Signs out the current user.

**Emits:** `sign_out_success`. It also emits `auth_failure` on failure.

```gdscript
Firebase.auth.sign_out()
```
