# nginx unit example in perl

This repository gives a self-contained example of [ningx unit](https://unit.nginx.org/) application in perl.

See
* https://unit.nginx.org/
* https://github.com/nginx/unit

# Getting started

### 1. Build and install perl and nginx unit

```console
$ ./build.sh
---> NOTE: You can see progress at .build/build.log
---> 1/4. Building perl-5.26.1
---> 2/4. Installing Plack
---> 3/4. Cloning nginx/unit
---> 4/4. Building nginx/unit
```

This builds and installs:

* perl 5.26.1 to `./perl/bin/perl`
* nginx unit to `./unit/build/unitd`

### 2. Run nginx unit

```
$ ./unit/build/unitd --modules ./unit/build
```

This starts the nginx unit daemon in background.
Hint: You can start it in foreground by `--no-daemon`.

### 3. Register a perl application.

```
$ curl -X PUT -d @start.json --unix-socket ./control.unit.sock http://localhost/
```

### 4. Access `http://127.0.0.1:8300`

```
$ curl -v http://127.0.0.1:8300/
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to 127.0.0.1 (127.0.0.1) port 8300 (#0)
> GET / HTTP/1.1
> Host: 127.0.0.1:8300
> User-Agent: curl/7.57.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Content-Length: 23
< Server: unit/0.6
<
Hello world from PSGI!
* Connection #0 to host 127.0.0.1 left intact
```
:+1: :+1: :+1:

# TODO

* benchmark
* test it with [Plack::Test::Suite](https://metacpan.org/pod/Plack::Test::Suite)

# License

MIT
