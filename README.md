# mob - stress stateless web APIs

**mob** is small Erlang application to stress test HTTP APIs.

## Example

```erlang
mob:start().

%% Issues a random request ConnPid, a Gun connection,
%% returning the stream reference.
stream(ConnPid) ->
  Stream = random_stream(),
  stream(Stream, GunConnection).

Concurrency = 5.

mob:add(fun (ConnPid) -> stream(ConnPid) end, Concurrency).
```

## License

[MIT License](https://raw.github.com/michaelnisi/mob/master/LICENSE)
