# dungeon
### Peter Svensson <psvensson@gmail..com>_

This is jsut mee goofing off for a bit, nothing works and it might stay that way for some time :)

But when it does work, this is how:
First go to the directory where you cloned this rep, then start a lisp from the command-line, perhaps SBCL.
In that REPL, load the system

``` common-lisp
(ql:quickload :dungeon)
```

However, the idea is to start a small server like this 

``` common-lisp
(dungeon:start-wsd-server)

```
And then start a client, which can either connect to localhost (default) or (soon) to be directed to another url of an external server.


``` common-lisp
(dungeon:start-ui)
```

## License

MIT

