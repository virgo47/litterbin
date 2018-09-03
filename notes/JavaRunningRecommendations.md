# Recommendations for running Java applications

Know various JVM flags:
* http://blog.codecentric.de/en/2012/07/useful-jvm-flags-part-1-jvm-types-and-compiler-modes/
* http://blog.codecentric.de/en/2012/07/useful-jvm-flags-part-2-flag-categories-and-jit-compiler-diagnostics/
* http://blog.codecentric.de/en/2012/07/useful-jvm-flags-part-3-printing-all-xx-flags-and-their-values/
* http://blog.codecentric.de/en/2012/07/useful-jvm-flags-part-4-heap-tuning/
* http://blog.codecentric.de/en/2012/08/useful-jvm-flags-part-5-young-generation-garbage-collection/

## Basic flags for running Java 8 (and before)

* `-server` pays off after just couple of seconds, but is probably obsolete now with Java 8 and on,
as its tiered compilation is kinda best-of client/server worlds two-in-one magic combo (without
any explicit flag needed)
* `-showversion` prints used Java version (but does not finish JVM like `-version` and runs the app)
* `-XX:+PrintCommandLineFlags` documents all set flags (stdout) and couple of heap-related even if
not modified explicitly
* `-XX:+HeapDumpOnOutOfMemoryError` and `-XX:HeapDumpPath=<path>` to enable dump on
`OutOfMemoryError`, also see `-XX:OnOutOfMemoryError` to run any particular OS command when OOM
occurs
* `-verbose:gc -Xloggc:<path-to-file> -XX:+PrintGCDetails -XX:+PrintTenuringDistribution` to log
GC activity, see also [Ben Evans' this video](https://www.infoq.com/presentations/Visualizing-Java-GC)
(around 38min) and (some) *Java Performance* book, they are totally OK for production, we just need
enough disk space, we can rotate GC logs with `-XX:+UseGCLogFileRotation
-XX:NumberOfGCLogFiles=<number of files> -XX:GCLogFileSize=<number>M`

So the command line may look like this:

```
java -server -showversion -XX:+PrintCommandLineFlags \
  -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/ -XX:OnOutOfMemoryError="sh ~/cleanup.sh" \
  -verbose:gc -XX:+PrintGCDetails -XX:+PrintTenuringDistribution -Xloggc:/var/tmp/heapdumps
```


## Java 9+ startup flags

This is just a work in progress:
```
java -showversion -XX:+PrintCommandLineFlags \
  -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$LOG_DIR \
  -Xlog:gc:$LOG_DIR/gc.log:time,uptime,level,tags,tid  
```

Option `-Xlog:gc:...` seems to sum up GC nicely, `:gc*:` is very verbose with not that much
additional information (mostly just better precision).
When file output for `Xlog` is used without `output-options` (behind decorators):

* Default `filecount` (rotation) is 5 files (current + suffixes 0-4).
* Default `filesize` is 20MB.

Both can be found using (you may want to remove `gc.log` afterwards):
```
java -Xlog:logging=debug:gc.log -version && grep file gc.log
```

See [this blog](https://blog.codefx.org/java/unified-logging-with-the-xlog-option/) for more
information about Unified JVM Logging.

## Monitoring

Resources:
* [5 Techniques to Improve Your Server Logging](http://blog.takipi.com/5-techniques-to-improve-your-server-logging/)
(Tal Weiss, Takipi) - very useful tricks, especially thread naming!
* [Fixing Code at 100mph: Techniques to Improve How You Debug Servers](https://youtu.be/7KS4L-mA_-c),
another Tal Weiss' video about thread naming, Btrace, custom Java and Native agent
* https://zeroturnaround.com/rebellabs/how-to-inspect-classes-in-your-jvm/ about Java agens and HSDB

Tips:
* Name your threads, change the name as the important state changes.
* [Btrace](https://github.com/btraceio/btrace) - dynamic prod-safe tracing tool, does not modify
any state (that implies a lot of limitations), Java-like syntax
* Custom agents, class-instrumentation, [ASM](http://asm.ow2.org/) recommended for this, there are
also tools that help convert our Java code to ASM visitor code, e.g. [ASM Bytecode
Outline](https://plugins.jetbrains.com/plugin/5918) for IntelliJ IDEA.
* The Serviceability API: HSDB (HotSpot Debuger) - out-of-process debugger, incredible
introspection, searching object/variables using QL. 

### HotSpot Debugger (Oracle JVM only!)

Uses Serviceability API. To run it:

```
java -cp $JAVA_HOME/lib/sa-jdi.jar sun.jvm.hotspot.HSDB
```

Seems we have to use exactly the same version like the Java process (the same JDK). Reportedly
both intraprocess (with `sa-jdi.jar` on the CLASSPATH, I presume) and interprocess.