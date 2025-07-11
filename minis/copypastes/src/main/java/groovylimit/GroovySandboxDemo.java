package groovylimit;

import groovy.lang.GroovyShell;
import groovy.lang.Script;
import org.codehaus.groovy.ast.expr.Expression;
import org.codehaus.groovy.ast.expr.MethodCallExpression;
import org.codehaus.groovy.control.CompilerConfiguration;
import org.codehaus.groovy.control.customizers.SecureASTCustomizer;

import java.util.List;

public class GroovySandboxDemo {

    public static void main(String[] args) {
        CompilerConfiguration config = new CompilerConfiguration();
        SecureASTCustomizer secure = new SecureASTCustomizer();

        secure.setAllowedImports(List.of("java.util.*"));
        secure.setAllowedConstantTypesClasses(List.of(Object.class, Integer.class, String.class, Boolean.class));
        secure.setDisallowedReceiversClasses(List.of(Runtime.class, ProcessBuilder.class));
        secure.addExpressionCheckers(expression -> {
            if (expression instanceof MethodCallExpression mce) {
                Expression receiver = mce.getObjectExpression();
                String methodName = mce.getMethodAsString();

                // Block only "execute()" on String instances
                if ("execute".equals(methodName) &&
                        receiver.getType().getName().equals("java.lang.String")) {
                    return false;
                }
            }
            return true;
        });

        // Apply the secure customizer
        config.addCompilationCustomizers(secure);

        // The Groovy script to evaluate
        String scriptText = """
                    println "Hello from Groovy!"
                    var x = new Object().getClass()
                    println x
                    def output = "ls -la".execute().text  // This should fail
//                    println output
                """;

        // Create Groovy shell with the secured config
        GroovyShell shell = new GroovyShell(GroovySandboxDemo.class.getClassLoader(), config);

        try {
            Script script = shell.parse(scriptText);
            script.run();
        } catch (Exception e) {
            System.err.println("Script execution blocked or failed: " + e.getMessage());
        }
    }
}
