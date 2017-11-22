# Groovy tips and tricks


## Running Groovy script from (Maven) project in CLI

Running Groovy script in a project (let's say in `src/test/groovy/somepkg`) in IDE is easy,
at least in IDEA. Oftentimes it requires initial effort to mark `groovy` directory as a Source
Root (in our example Test Source Root, to be precise). IDEA does the rest, ensures proper classpath
is set, uses proper encoding for files, etc.

Following examples are from git-bash on Windows so they may require changes in separators and
escaping, e.g. `;` vs `:` in classpath, etc.

If there are little to no dependencies there may be no problem running the commands without
specifying the classpath, but that's unlikely scenario. So the first thing we want is to get
the classpath. For Maven projects we can go to the root of the project/module and run:

```
mvn -Dmdep.outputFile=classpath.txt dependency:build-classpath
```

This exports the classpath including test scope, but not the `target/test-classes` itself.

TODO: How to do this in Gradle? `gradle dependencies --configuration=testRuntime` shows the tree
but not the files in required format.


### Running with `groovy` command

If the project is built, we can run it from the root directory of the project/module like this:

```
groovy -cp target/test-classes\;`cat classpath.txt` --encoding UTF-8 \
  src/test/groovy/somepkg/SomeScript.groovy
```

The key notion here is that *we can use other directory separator (slash instead of escaped
backslash) but we have to use proper multi-path separator for the platform. On Windows we have to
use the semicolon `;` and not colon `:` even though we're using Linux like bash.

Alternative is to put sources in the classpath instead of target (test) classes, which is viable
for Groovy sources (packages work fine, point to the source root):

```
groovy -cp src/test/groovy\;`cat classpath.txt` --encoding UTF-8 \
  src/test/groovy/somepkg/SomeScript.groovy
```

Of course, we can mix these. Advantage of using `src/.../groovy` is that we don't need to recompile
the script (and other Groovy scripts/classes) after change.
 

### Running with `java` command

To run the same with `java` instead of `groovy` we presume that Groovy is also on the classpath,
probably as an item in that `classpath.txt`. We can use the same classpath options like before,
we only need to replace `groovy` with `java`, `--encoding UTF-8` with `-Dfile.encoding=UTF-8`
and add classname `groovy.ui.GroovyMain` before the name of the script:
 
```
java -cp target/test-classes\;`cat classpath.txt` -Dfile.encoding=UTF-8 groovy.ui.GroovyMain \
  src/test/groovy/somepkg/SomeScript.groovy
```

