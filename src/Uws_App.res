/**
TemplatedApp is either an SSL or non-SSL app. See App for more info, read user manual.
*/
type t

/**
Options used when constructing an app. Especially for SSLApp.
These are options passed directly to uSockets, C layer.
*/
type appOptionsT = {
  key_file_name?: string,
  cert_file_name?: string,
  ca_file_name?: string,
  passphrase?: string,
  dh_params_file_name?: string,
  ssl_ciphers?: string,
  /** This translates to SSL_MODE_RELEASE_BUFFERS */
  ssl_prefer_low_memory_usage?: bool,
}

/** 
Constructs a non-SSL app. An app is your starting point where you attach behavior to URL routes.
This is also where you listen and run your app, set any SSL options (in case of SSLApp) and the like.
*/
@module("uWebsockets.js")
external makeApp: appOptionsT => t = "App"

/** Constructs an SSL app. See App. */
@module("uWebsockets.js")
external makeSSLApp: appOptionsT => t = "SSLApp"

type listenOptionsT =
  | LIBUS_LISTEN_DEFAULT
  | LIBUS_LISTEN_EXCLUSIVE_PORT

type socketCallbackT = unit => unit
type socketCallbackAsyncT = unit => Js.Promise.t<unit>

/** Listens to hostname & port. Callback hands either false or a listen socket. */
@send
external listenWithHostname: (t, string, int, socketCallbackT) => t = "listen"
@send
external listenWithHostnameAsync: (t, string, int, socketCallbackAsyncT) => t = "listen"
/** Listens to port. Callback hands either false or a listen socket. */
@send
external listen: (t, int, socketCallbackT) => t = "listen"
@send
external listenAsync: (t, int, socketCallbackAsyncT) => t = "listen"
/** Listens to port and sets Listen Options. Callback hands either false or a listen socket. */
@send
external listenWithOptions: (t, int, listenOptionsT, socketCallbackT) => t = "listen"
@send
external listenWithOptionsAsync: (t, int, listenOptionsT, socketCallbackAsyncT) => t = "listen"

type handlerT = (Uws_Response.t, Uws_Request.t) => unit
type handlerAsyncT = (Uws_Response.t, Uws_Request.t) => Js.Promise.t<unit>

/** Registers an HTTP GET handler matching specified URL pattern. */
@send
external get: (t, string, handlerT) => t = "get"
@send
external getAsync: (t, string, handlerAsyncT) => t = "get"
/** Registers an HTTP POST handler matching specified URL pattern. */
@send
external post: (t, string, handlerT) => t = "post"
@send
external postAsync: (t, string, handlerAsyncT) => t = "post"
/** Registers an HTTP OPTIONS handler matching specified URL pattern. */
@send
external options: (t, string, handlerT) => t = "options"
@send
external optionsAsync: (t, string, handlerAsyncT) => t = "options"
/** Registers an HTTP DELETE handler matching specified URL pattern. */
@send
external del: (t, string, handlerT) => t = "del"
@send
external delAsync: (t, string, handlerAsyncT) => t = "del"
/** Registers an HTTP PATCH handler matching specified URL pattern. */
@send
external patch: (t, string, handlerT) => t = "patch"
@send
external patchAsync: (t, string, handlerAsyncT) => t = "patch"
/** Registers an HTTP PUT handler matching specified URL pattern. */
@send
external put: (t, string, handlerT) => t = "put"
@send
external putAsync: (t, string, handlerAsyncT) => t = "put"
/** Registers an HTTP HEAD handler matching specified URL pattern. */
@send
external head: (t, string, handlerT) => t = "head"
@send
external headAsync: (t, string, handlerAsyncT) => t = "head"
/** Registers an HTTP CONNECT handler matching specified URL pattern. */
@send
external connect: (t, string, handlerT) => t = "connect"
@send
external connectAsync: (t, string, handlerAsyncT) => t = "connect"
/** Registers an HTTP TRACE handler matching specified URL pattern. */
@send
external trace: (t, string, handlerT) => t = "trace"
@send
external traceAsync: (t, string, handlerAsyncT) => t = "trace"
/** Registers an HTTP handler matching specified URL pattern on any HTTP method. */
@send
external any: (t, string, handlerT) => t = "any"
@send
external anyAsync: (t, string, handlerAsyncT) => t = "any"
/** Registers a handler matching specified URL pattern where WebSocket upgrade requests are caught. */
@send
external ws: (t, string, Uws_Websocket.websocketBehaviorT<'a>) => t = "ws"
/** Publishes a message under topic, for all WebSockets under this app. See WebSocket.publish. */
@send
external publish: (t, string, string) => bool = "publish"
/** Returns number of subscribers for this topic. */
@send
external numSubscribers: (t, string) => float = "numSubscribers"
/** Adds a server name. */
@send
external addServerName: (t, string, appOptionsT) => t = "addServerName"
/** Browse to SNI domain. Used together with .get, .post and similar to attach routes under SNI domains. */
@send
external domain: (t, string) => t = "domain"
/** Removes a server name. */
@send
external removeServerName: (t, string) => t = "removeServerName"
/** Registers a synchronous callback on missing server names. See /examples/ServerName.js. */
@send
external missingServerName: (t, string => unit) => t = "missingServerName"
