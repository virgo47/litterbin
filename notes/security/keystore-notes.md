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

## Updating cacert 2022

After adding fresh JDK 17, Maven first failed on being too old to handle it, so I upgraded to 3.8 (added new Maven).
Then it failed with:

````
...PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target -> [Help 1]
````

To fix this I used this answer: https://stackoverflow.com/a/53886108/658826

As root:

1. I went to my new favourite JDK:
````
cd /usr/lib/jvm/zulu17.28.13-ca-jdk17.0.0-linux_x64
````

2. Download the certificate as PEM file using keytool:
````
bin/keytool  -printcert -rfc -sslserver nexus.evolveum.com > ~/nexus_evolveum_com.pem
````

4. Install it to cacert file:
````
find -iname cacerts # printed ./lib/security/cacerts
bin/keytool -importcert -file ~/nexus_evolveum_com.pem -keystore lib/security/cacerts
````

Next Maven run was the happy one.

TODO: What happens when server certificate is renewed?
The process must be repeated (how to remove old cert?) I guess.
It's better to use root certificate.
