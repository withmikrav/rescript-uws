/** An HttpRequest is stack allocated and only accessible during the callback invocation. */
type t

type arrayBufferT = Js.TypedArray2.array_buffer

/** Returns the lowercased header value or empty string. */
@send
external getHeader: (t, string) => string = "getHeader"
@send
external getHeaderArrayBuffer: (t, arrayBufferT) => string = "getHeader"

/** Returns the parsed parameter at index. Corresponds to route. */
@send
external getParameter: (t, int) => string = "getParameter"

/** Returns the URL including initial /slash */
@send
external getUrl: (t, unit) => string = "getUrl"

/** Returns the lowercased HTTP method, useful for "any" routes. */
@send
external getMethod: (t, unit) => string = "getMethod"

/** Returns the HTTP method as-is. */
@send
external getCaseSensitiveMethod: (t, unit) => string = "getCaseSensitiveMethod"

/** Returns the raw querystring (the part of URL after ? sign) or empty string. */
@send
external getQuery: (t, unit) => string = "getQuery"

type queryKeyT = string
/** Returns a decoded query parameter value or empty string. */
@send
external getQueryWithKey: (t, queryKeyT) => string = "getQuery"

type headerKeyT = string
type headerValueT = string
/** Loops over all headers. */
@send
external forEach: (t, (headerKeyT, headerValueT) => unit) => unit = "forEach"

/** Setting yield to true is to say that this route handler did not handle the route, causing the router to continue looking for a matching route handler, or fail. */
@send
external setYield: (t, bool) => t = "setYield"
