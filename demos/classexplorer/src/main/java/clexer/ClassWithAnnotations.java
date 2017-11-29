package clexer;

@ClassRetentionAnnotation
public class ClassWithAnnotations {

	public void methodVoid() {
	}

	@ClassRetentionAnnotation("something")
	public String annotatedMethodReturningString() {
		return "";
	}
}
