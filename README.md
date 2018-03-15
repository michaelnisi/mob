# mob - stress stateless web APIs

*mob* is small Erlang application to stress test HTTP APIs.

## Example

With `random_gun_request/1` issuing a random *gun* request, on the [*gun*](https://github.com/ninenines/gun) connection it received as its sole argument, and returning the identifier of the stream; this example would hit `"localhost"` on port `8000` on five *gun* connections—continuously, variated slightly in timing, until *mob* is stopped with `mob:stop/0`.

```erlang
mob:start("localhost", 8000).
mob:add(fun random_gun_request/1, 5).
```

## Types

### ConnPid = pid()

The pid of the Gun connection process.

### StreamRef = reference()

Identifier of the HTTP stream initiated by the owner process.

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
