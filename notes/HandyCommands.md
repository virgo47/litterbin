# Handy commands

## Networking

* On Linux, use `ss` instead of `netstat`, e.g. `ss -l` for listen ports.

* Check programs listening on Windows: `netstat -abno | grep -i listen`

* Windows GUI application for network ports/processes: `tcpview` (available via Chocolatey)

## Curl

Curl has many switches, but some are very useful most of the time:

```
curl -fsSkL -C - -o <output-file> <url>
```       

* `-f` fail, handy in scripts with `set -eu` to abort them on non-200/300 reply (or other error),
* `-s` silent, doesn't show progress, etc.
* `-S` print error output, even with `-s` (`-f` also fails silently), very important feedback
* `-k` ignores certificate when using TLS (think twice, but often handy in internal networks)
* `-L` follow redirects (HTTP 3xx), like download link taken from a pages that is just redirect
* `-C -` continue/resume, offset is determined automatically
* `-o <output-file>` to save under specific name

To POST JSON from file `some.json` somewhere:
```
curl -fsSk -d @some.json \
  -H "Content-Type: application/json" \
  -H "Other-Header: like API key or what" \
  <url>
```

To POST JSON from stdin (`-d @-`), here using here string with verbose output (`-v`, overrides `-s`):
```                             
curl -fsSk -d @- http://localhost:8080/some/service -v <<< '{"id":1}' 
```                                                                 

Without header it sends `Accept: */*` which may work for `GET` but typically not for `POST`.
