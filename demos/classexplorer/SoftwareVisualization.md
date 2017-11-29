# Visualization theses

* Visualization should use processed data, some information, preferably some good model.
* Model can be created from sources and/or from class files.
* Class files are unified on JVM, sources depend on used programming language. I can try to use
class files as primary source of data with sources being secondary.
* Parsing class files seems to be solved problem, e.g. with BCEL. What model make from the data?
* There should be clear separation of project classes/artifacts from non-project/3rd-party
(libraries, JDK, ...).
* Multi-module project structure should be preserved (Maven/Gradle) preferably with dependencies.
Model must know what is in which module/artifact.