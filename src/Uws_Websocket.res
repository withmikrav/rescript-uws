/**
A WebSocket connection that is valid from open to close event.
Read more about this in the user manual.
*/
type t<'data>

type arrayBufferT = Js.TypedArray2.array_buffer

/**
Sends a message. Returns 1 for success, 2 for dropped due to backpressure limit, and 0 for built up backpressure that will drain over time. You can check backpressure before or after sending by calling getBufferedAmount().
Make sure you properly understand the concept of backpressure. Check the backpressure example file.
*/
@send
external send: (t<'data>, string) => float = "send"

/**
Returns the bytes buffered in backpressure. This is similar to the bufferedAmount property in the browser counterpart.
Check backpressure example.
*/
@send
external getBufferedAmount: (t<'data>, string) => float = "getBufferedAmount"

/**
Gracefully closes this WebSocket. Immediately calls the close handler.
A WebSocket close message is sent with code and shortMessage.
*/
@send
external end: (t<'data>, unit) => unit = "end"

/** 
Forcefully closes this WebSocket. Immediately calls the close handler.
No WebSocket close message is sent.
*/
@send
external close: (t<'data>, unit) => unit = "close"

/** Sends a ping control message. Returns sendStatus similar to WebSocket.send (regarding backpressure). This helper function correlates to WebSocket::send(message, uWS::OpCode::PING, ...) in C++. */
@send
external ping: (t<'data>, string) => int = "ping"

/** Subscribe to a topic. */
@send
external subscribe: (t<'data>, string) => bool = "subscribe"

/** Unsubscribe from a topic. Returns true on success, if the WebSocket was subscribed. */
@send
external unsubscribe: (t<'data>, string) => bool = "unsubscribe"

/** Returns whether this websocket is subscribed to topic. */
@send
external isSubscribed: (t<'data>, string) => bool = "isSubscribed"

/** Returns a list of topics this websocket is subscribed to. */
@send
external getTopics: (t<'data>, unit) => array<string> = "getTopics"

/**
Publish a message under topic. Backpressure is managed according to maxBackpressure, closeOnBackpressureLimit settings.
Order is guaranteed since v20.
*/
@send
external publish: (t<'data>, string, string) => bool = "publish"

/** See HttpResponse.cork. Takes a function in which the socket is corked (packing many sends into one single syscall/SSL block) */
@send
external cork: (t<'data>, unit => unit) => t<'data> = "cork"

/** 
Returns the remote IP address. Note that the returned IP is binary, not text.

IPv4 is 4 byte long and can be converted to text by printing every byte as a digit between 0 and 255.
IPv6 is 16 byte long and can be converted to text in similar ways, but you typically print digits in HEX.

See getRemoteAddressAsText() for a text version.
*/
@send
external getRemoteAddress: (t<'data>, unit) => arrayBufferT = "getRemoteAddress"

/** Returns the remote IP address as text. See RecognizedString. */
@send
external getRemoteAddressAsText: (t<'data>, unit) => arrayBufferT = "getRemoteAddressAsText"

/** Returns the UserData object. */
@send
external getUserData: (t<'data>, unit) => 'data = "getUserData"

/** A structure holding settings and handlers for a WebSocket URL route handler. */
type websocketBehaviorT<'userData> = {
  /** Maximum length of received message. If a client tries to send you a message larger than this, the connection is immediately closed. Defaults to 16 * 1024. */
  maxPayloadLength?: int,
  /** Whether or not we should automatically close the socket when a message is dropped due to backpressure. Defaults to false. */
  closeOnBackpressureLimit?: int,
  /** Maximum number of minutes a WebSocket may be connected before being closed by the server. 0 disables the feature. */
  maxLifetime?: int,
  /**
  Maximum amount of seconds that may pass without sending or getting a message. Connection is closed if this timeout passes. Resolution (granularity) for timeouts are typically 4 seconds, rounded to closest.
  Disable by using 0. Defaults to 120.
  */
  idleTimeout?: int,
  /** What permessage-deflate compression to use. uWS.DISABLED, uWS.SHARED_COMPRESSOR or any of the uWS.DEDICATED_COMPRESSOR_xxxKB. Defaults to uWS.DISABLED. */
  compression?: int,
  /** Maximum length of allowed backpressure per socket when publishing or sending messages. Slow receivers with too high backpressure will be skipped until they catch up or timeout. Defaults to 64 * 1024. */
  maxBackpressure?: int,
  /** Whether or not we should automatically send pings to uphold a stable connection given whatever idleTimeout. */
  sendPingsAutomatically?: bool,
  /**
  Upgrade handler used to intercept HTTP upgrade requests and potentially upgrade to WebSocket.
  See UpgradeAsync and UpgradeSync example files.
  */
  upgrade?: (Uws_Response.t, Uws_Request.t, {.}) => Js.Promise.t<unit>,
  /** Handler for new WebSocket connection. WebSocket is valid from open to close, no errors. */
  @as("open")
  open_?: t<'userData> => Js.Promise.t<unit>,
  /** Handler for a WebSocket message. Messages are given as ArrayBuffer no matter if they are binary or not. Given ArrayBuffer is valid during the lifetime of this callback (until first await or return) and will be neutered. */
  message?: (t<'userData>, arrayBufferT, bool) => Js.Promise.t<unit>,
  /** Handler for when WebSocket backpressure drains. Check ws.getBufferedAmount(). Use this to guide / drive your backpressure throttling. */
  drain?: t<'userData> => unit,
  /** Handler for close event, no matter if error, timeout or graceful close. You may not use WebSocket after this event. Do not send on this WebSocket from within here, it is closed. */
  close?: (t<'userData>, int, arrayBufferT) => unit,
  /** Handler for received ping control message. You do not need to handle this, pong messages are automatically sent as per the standard. */
  ping?: (t<'userData>, arrayBufferT) => unit,
  /** Handler for received pong control message. */
  pong?: (t<'userData>, arrayBufferT) => unit,
  /** Handler for subscription changes. */
  subscription?: (t<'userData>, arrayBufferT, int, int) => unit,
}
