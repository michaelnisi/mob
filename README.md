# mob - stress stateless web APIs

*mob* is small Erlang application to stress test HTTP APIs.

## Example

With `random_gun_request/1` issuing a random *Gun* request, on the [*Gun*](https://github.com/ninenines/gun) connection it received as its sole argument, and returning the identifier of the stream; this example would hit `"localhost"` on port `8000` on five *gun* connections—continuously, variated slightly in timing, until *mob* is stopped with `mob:stop/0`.

```erlang
mob:start("localhost", 8000).
mob:add(fun random_gun_request/1, 5).
```

## Types

### A Gun Connection

`ConnPid = pid()` 

The pid of the *Gun* connection process.

### HTTP Response Stream

`StreamRef = reference()` 

Identifier of a HTTP response stream for a request. *Gun* supports HTTP/1.1, HTTP/2 and Websocket.

## Exports

### Starting Mob

```erlang
mob:start(Host, Port) -> ok | {error, Reason}
```
- `Host = string()`
- `Port = integer() >= 1`

### Adding Workers

```erlang
mob:add(StreamFun, Concurrency) -> [startchild_ret()]
```
- `StreamFun = fun(ConnPid) -> StreamRef`
- `Concurrency = integer() >= 1`

## License

[MIT License](https://raw.github.com/michaelnisi/mob/master/LICENSE)
