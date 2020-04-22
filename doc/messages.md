[[_TOC_]]


General notes
-------------

* All values are little endian.


Error codes
-----------

The device can respond with the following error codes:

| Value | Meaning      |
| ----- | ------------ |
| 0     | Success      |
| 1     | Out of range |

> **TODO**: More error codes.


Message definitions
-------------------

### Response

* Sent for any message that requires a response.

| Byte offset | Bytes | Purpose    | Value             |
| ----------- | ----- | ---------- | ----------------- |
| 0           | 1     | Message ID | `0`               |
| 1           | 1     | Respond ID | `1`-`N_MSG_TYPES` |
| 2           | 2     | Reserved   | Must be zero      |
| 4           | 4     | Error code | See error codes   |

### Enable LED

* Signals to the device to set a given LED to a given flash pattern.
* Expects a response message.

| Byte offset | Bytes | Purpose    | Value            |
| ----------- | ----- | ---------- | ---------------- |
| 0           | 1     | Message ID | `1`              |
| 1           | 1     | LED index  | `0`-`15`         |
| 2           | 2     | Reserved   | Must be zero     |
| 4           | 4     | On-delay   | `0`-`UINT32_MAX` |
| 8           | 4     | Off-delay  | `0`-`UINT32_MAX` |

> **TODO**: Decide delay units.

### Stop all LEDs

* Stops all LEDs.
* Expects a response message.

> **Note**: Use Enable LED message with a zero On-delay to stop a single LED.

| Byte offset | Bytes | Purpose    | Value            |
| ----------- | ----- | ---------- | ---------------- |
| 0           | 1     | Message ID | `2`              |

### Start sampling

* Start sampling a photodiode.
* Expects a response message.

| Byte offset | Bytes | Purpose          | Value            |
| ----------- | ----- | ---------------- | ---------------- |
| 0           | 1     | Message ID       | `3`              |
| 0           | 1     | Photodiode index | `0`-`3`          |

> **TODO**: We might want to pass a sampling rate.

### Stop sampling

* Stop sampling a photodiode.
* Expects a response message.

| Byte offset | Bytes | Purpose          | Value            |
| ----------- | ----- | ---------------- | ---------------- |
| 0           | 1     | Message ID       | `4`              |
| 0           | 1     | Photodiode index | `0`-`3`          |

### Reset

* Reset the device.
* Expects a response message.

| Byte offset | Bytes | Purpose          | Value            |
| ----------- | ----- | ---------------- | ---------------- |
| 0           | 1     | Message ID       | `5`              |


Data samples
------------

Sample data from the diodes will consist of unsigned 16-bit values.
There will be 16 samples per chunk.

There will be a header before each chunk:

| Byte offset | Bytes | Purpose          | Value            |
| ----------- | ----- | ---------------- | ---------------- |
| 0           | 1     | Photodiode index | `0`-`3`          |
| 1           | 1     | Reserved         | Must be zero     |
| 2           | 2     | Checksum         | `0x0`-`0xffff`   |

