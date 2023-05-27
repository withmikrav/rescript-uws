open Uws

let app = makeApp({})

app
->any("/*", (res, _req) => {
  res
  ->Response.writeStatus("200 OK")
  ->Response.writeHeader("IsExample", "Yes")
  ->Response.end("Hello world")
  ->ignore
})
->listen(3000, () => {
  Js.log("hello")
})
->ignore
