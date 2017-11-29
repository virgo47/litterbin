package clexer;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;

import org.apache.bcel.classfile.AnnotationEntry;
import org.apache.bcel.classfile.ClassParser;
import org.apache.bcel.classfile.ConstantPool;
import org.apache.bcel.classfile.JavaClass;
import org.apache.bcel.classfile.Method;
import org.objectweb.asm.ClassReader;
import org.objectweb.asm.tree.ClassNode;

public class Main {

	public static final String CLASS_FILE =
		"C:\\work\\workspace\\litterbin\\demos\\classexplorer\\build\\classes\\java\\main\\" +
			"clexer\\ClassWithAnnotations.class";

	public static void main(String[] args) throws Exception {
		asmExample();
//		bcelExample();
	}

	private static void asmExample() throws Exception {
		InputStream in = new FileInputStream(CLASS_FILE);

		ClassReader cr = new ClassReader(in);
		ClassNode classNode = new ClassNode();

		cr.accept(classNode, 0);

		System.out.println("classNode = " + classNode);
		System.out.println("classNode.invisibleAnnotations = " + classNode.invisibleAnnotations);
	}

	private static void bcelExample() throws IOException {
		ClassParser cp = new ClassParser(CLASS_FILE);
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
}
