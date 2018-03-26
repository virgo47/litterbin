# Keytool and certificates

To see the details of a certificate:

```
keytool -keystore jssecacerts -storepass changeit -list -v -alias <cert-alias>
```

To print it in RFC style replace `-v` with `-rfc`.

More about this and also how to extract public key from the certificate:
http://stackoverflow.com/q/10103657/658826


## Working with default `cacerts`

This file is located:

* under `jre/lib/security` for JDK 8 and lower,
* under `lib/security` for JDK 9+ and all recent JREs.

In JDK 9 and later you don't have to use `-keystore <path-to-it>/cacerts` but you can use
simple `-cacerts` instead - default `cacerts` file will be used automatically.
This can be used with many commands (`-delete`, `-list`, ...) but not all (e.g. `-importkystore`).


## Updating JRE/JDK cacert with another key

See [this script](update-default-cacert-store.sh). 