/**
An HttpResponse is valid until either onAborted callback or any of the .end/.tryEnd calls succeed. You may attach user data to this object.

Writes the HTTP status message such as "200 OK".
This has to be called first in any response, otherwise
it will be called automatically with "200 OK".

If you want to send custom headers in a WebSocket
upgrade response, you have to call writeStatus with
"101 Switching Protocols" before you call writeHeader,
otherwise your first call to writeHeader will call
writeStatus with "200 OK" and the upgrade will fail.

As you can imagine, we format outgoing responses in a linear
buffer, not in a hash table. You can read about this in
the user manual under "corking".
*/
type t

type arrayBufferT = Js.TypedArray2.array_buffer

/** Pause http body streaming (throttle) */
@send
external pause: unit => unit = "pause"

/** Resume http body streaming (unthrottle) */
@send
external resume: unit => unit = "resume"

type statusT = string
/** Writes the HTTP status message such as "200 OK" */
@send
external writeStatus: (t, statusT) => t = "writeStatus"
@send
external writeStatusArrayBuffer: (t, arrayBufferT) => t = "writeStatus"

type headerKeyT = string
type headerValueT = string
/** 
Writes key and value to HTTP response.

See writeStatus and corking.
*/
@send
external writeHeader: (t, headerKeyT, headerValueT) => t = "writeHeader"
@send
external writeHeaderArrayBuffer: (t, arrayBufferT, arrayBufferT) => t = "writeHeader"

type chunkT = string
/** Enters or continues chunked encoding mode. Writes part of the response. End with zero length write. Returns true if no backpressure was added. */
@send
external write: (t, chunkT) => bool = "write"
@send external writeArrayBuffer: (t, arrayBufferT) => bool = "write"

/** Ends this response by copying the contents of body. */
@send
external end: (t, string) => t = "end"
@send external endArrayBuffer: (t, arrayBufferT) => t = "end"
type closeConnectionT = bool
@send
external endWithCloseConnection: (t, string, closeConnectionT) => t = "end"
@send
external endArrayBufferWithCloseConnection: (t, arrayBufferT, closeConnectionT) => t = "end"

type reportedContentLengthT = int
/** Ends this response without a body. */
@send
external endWithoutBody: (t, unit) => t = "endWithoutBody"
external endWithoutBodyWithReportedContentLength: (t, reportedContentLengthT) => t =
  "endWithoutBody"
external endWithoutBodyWithReportedContentLengthAndCloseConnection: (
  t,
  reportedContentLengthT,
  closeConnectionT,
) => t = "endWithoutBody"

type totalSizeT = string
/** Ends this response, or tries to, by streaming appropriately sized chunks of body. Use in conjunction with onWritable. Returns tuple [ok, hasResponded].*/
@send
external tryEnd: (t, string, int) => (bool, bool) = "tryEnd"
@send
external tryEndArrayBuffer: (t, arrayBufferT, int) => (bool, bool) = "tryEnd"

/** Immediately force closes the connection. Any onAborted callback will run. */
@send
external close: (t, unit) => t = "close"

/** Returns the global byte write offset for this response. Use with onWritable. */
@send
external getWriteOffset: (t, unit) => float = "getWriteOffset"

type offsetT = float
type writableHandlerT = offsetT => bool
/**
Registers a handler for writable events. Continue failed write attempts in here.
You MUST return true for success, false for failure.
Writing nothing is always success, so by default you must return true.
*/
@send
external onWritable: (t, writableHandlerT) => t = "onWritable"

/**
Every HttpResponse MUST have an attached abort handler IF you do not respond
to it immediately inside of the callback. Returning from an Http request handler
without attaching (by calling onAborted) an abort handler is ill-use and will terminate.
When this event emits, the response has been aborted and may not be used.
*/
@send
external onAborted: (t, unit => unit) => t = "onAborted"

type isLastT = bool

/** Handler for reading data from POST and such requests. You MUST copy the data of chunk if isLast is not true. We Neuter ArrayBuffers on return, making it zero length.*/
@send
external onData: (t, (arrayBufferT, isLastT) => unit) => t = "onData"

/** Returns the remote IP address in binary format (4 or 16 bytes). */
@send
external getRemoteAddress: (t, unit) => arrayBufferT = "getRemoteAddress"

/** Returns the remote IP address as text. */
@send
external getRemoteAddressAsText: (t, unit) => arrayBufferT = "getRemoteAddressAsText"

/** Returns the remote IP address in binary format (4 or 16 bytes), as reported by the PROXY Protocol v2 compatible proxy. */
@send
external getProxiedRemoteAddress: (t, unit) => arrayBufferT = "getProxiedRemoteAddress"

/** Returns the remote IP address as text, as reported by the PROXY Protocol v2 compatible proxy. */
@send
external getProxiedRemoteAddressAsText: (t, unit) => arrayBufferT = "getProxiedRemoteAddressAsText"

/** 
Corking a response is a performance improvement in both CPU and network, as you ready the IO system for writing multiple chunks at once.
By default, you're corked in the immediately executing top portion of the route handler. In all other cases, such as when returning from
await, or when being called back from an async database request or anything that isn't directly executing in the route handler, you'll want
to cork before calling writeStatus, writeHeader or just write. Corking takes a callback in which you execute the writeHeader, writeStatus and
such calls, in one atomic IO operation. This is important, not only for TCP but definitely for TLS where each write would otherwise result
in one TLS block being sent off, each with one send syscall.

Example usage:

```
res.cork(() => {
  res.writeStatus("200 OK").writeHeader("Some", "Value").write("Hello world!");
});
```
*/
@send
external cork: (t, unit => unit) => unit = "cork"

/** Upgrades a HttpResponse to a WebSocket. See UpgradeAsync, UpgradeSync example files. */
@send
external upgrade: ('a, string, string, string, 'b) => unit = "upgrade"

/** Arbitrary user data may be attached to this object */
@get_index
external getData: (t, string) => 'a = ""
