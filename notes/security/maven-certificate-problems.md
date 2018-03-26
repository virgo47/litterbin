# Maven problems with certificate

Using HTTPS Maven build can throw this:

```
[ERROR] [ERROR] Some problems were encountered while processing the POMs:
[FATAL] Non-resolvable parent POM for xxx:yyy:local-SNAPSHOT: Could not transfer artifact
  xxx:zzz:pom:1.1.0-... from/to <nexus-hostname> (<repository-URL>):
  sun.security.validator.ValidatorException: PKIX path building failed:
  sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification
  path to requested target and 'parent.relativePath' points at wrong local POM @ line 12, column 13
```

We can also debug the particular problem in more details:

```
mvn -Djavax.net.debug=ssl clean
```

What we need is some certificate that would make it run. Our options are:

* Downloading the certificate from the server directly and put in a trust store.
* Putting some root certificate into a trust store.
* Finally, let Maven ignore the certificate validation.

## Using certificate from the server

We use `InstallCert` to download the certificate from the server and put it into the trust keystore.
Then we can run Maven (here with specific settings XML as well) using specific trustStore:

```
mvn -s ~/.m2/settings-xy.xml -Djavax.net.ssl.trustStore=../../litterbin/jssecacerts clean
```

Sources: (../../minis/copypastes/src/main/java/tools/InstallCert.java)[InstallCert.java]

## Using root certificate

Probably the way how to get it into the trust store is the same, I just couldn't try it
as I didn't have any reasonable root CA.


## Ignoring certificate validation

We can add the following to the `mvn` command line:

```
-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true
```

This ignores all kinds of certificate issues:

* `maven.wagon.http.ssl.insecure=true` enables use of relaxed ssl check for user
generated certificates.
* `maven.wagon.http.ssl.allowall=true` enables match of the server's X.509 certificate with
hostname. If disabled, a browser like check will be used.
* `maven.wagon.http.ssl.ignore.validity.dates=true` ignores issues with certificate dates.