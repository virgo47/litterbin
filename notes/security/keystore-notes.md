# Keytool and certificates

To see the details of a certificate:

```
keytool -keystore jssecacerts -storepass changeit -list -v -alias <cert-alias>
```

To print it in RFC style replace `-v` with `-rfc`.

More about this and also how to extract public key from the certificate:
http://stackoverflow.com/q/10103657/658826


## Updating JRE/JDK cacert with another key