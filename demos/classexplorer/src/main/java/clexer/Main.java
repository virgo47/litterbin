package clexer;

import java.util.Arrays;

import org.apache.bcel.classfile.AnnotationEntry;
import org.apache.bcel.classfile.ClassParser;
import org.apache.bcel.classfile.ConstantPool;
import org.apache.bcel.classfile.JavaClass;
import org.apache.bcel.classfile.Method;

public class Main {

	public static void main(String[] args) throws Exception {
		ClassParser cp = new ClassParser("C:\\work\\workspace\\litterbin\\demos\\classexplorer\\build\\classes\\java\\main\\clexer\\ClassWithAnnotations.class");
		JavaClass jc = cp.parse();
		System.out.println("jc = " + jc);

		ConstantPool constantPool = jc.getConstantPool();
		System.out.println("constantPool = " + constantPool);

		for (AnnotationEntry annotationEntry : jc.getAnnotationEntries()) {
			System.out.println("annotationEntry = " + annotationEntry);
		}

		for (Method method : jc.getMethods()) {
			System.out.println("method = " + method);
			System.out.println(
				"method annotation = " + Arrays.toString(method.getAnnotationEntries()));
		}
	}

	private String convert(StringBuilder sb) {
		return sb.toString();
	}
}
