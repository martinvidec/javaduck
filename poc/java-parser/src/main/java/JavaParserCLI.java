import com.github.javaparser.StaticJavaParser;
import com.github.javaparser.ast.CompilationUnit;
import com.github.javaparser.ast.body.*;
import com.github.javaparser.ast.comments.JavadocComment;
import com.github.javaparser.ast.type.ClassOrInterfaceType;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.File;
import java.io.FileInputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

/**
 * CLI wrapper for JavaParser that outputs JSON
 * for consumption by Ruby JSDuck parser
 */
public class JavaParserCLI {

    public static void main(String[] args) {
        if (args.length < 1) {
            System.err.println("Usage: java JavaParserCLI <java-source-file>");
            System.exit(1);
        }

        try {
            String sourceFile = args[0];
            String source = new String(Files.readAllBytes(Paths.get(sourceFile)));

            CompilationUnit cu = StaticJavaParser.parse(source);

            List<Map<String, Object>> docsets = new ArrayList<>();

            // Process all types (classes, interfaces, enums)
            cu.getTypes().forEach(type -> {
                docsets.add(processTypeDeclaration(type, source));
            });

            // Output JSON
            Gson gson = new GsonBuilder().setPrettyPrinting().create();
            System.out.println(gson.toJson(docsets));

        } catch (Exception e) {
            System.err.println("Error parsing Java file: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }

    private static Map<String, Object> processTypeDeclaration(TypeDeclaration<?> type, String source) {
        Map<String, Object> docset = new LinkedHashMap<>();

        // Determine type
        String tagname = "class";
        if (type.isEnumDeclaration()) {
            tagname = "enum";
        } else if (type.isClassOrInterfaceDeclaration()) {
            ClassOrInterfaceDeclaration coid = type.asClassOrInterfaceDeclaration();
            if (coid.isInterface()) {
                tagname = "interface";
            }
        }

        docset.put("tagname", tagname);
        docset.put("name", type.getNameAsString());
        docset.put("type", "doc_comment");

        // Extract Javadoc
        String javadoc = "";
        if (type.getJavadocComment().isPresent()) {
            javadoc = type.getJavadocComment().get().getContent();
        }
        docset.put("comment", javadoc);

        // Line number
        docset.put("linenr", type.getBegin().map(pos -> pos.line).orElse(0));

        // Code structure
        Map<String, Object> code = new LinkedHashMap<>();
        code.put("tagname", tagname);
        code.put("name", type.getNameAsString());

        // Modifiers
        code.put("public", type.isPublic());
        code.put("private", type.isPrivate());
        code.put("protected", type.isProtected());
        code.put("static", type.isStatic());

        // final is only available for ClassOrInterfaceDeclaration
        boolean isFinal = false;
        if (type.isClassOrInterfaceDeclaration()) {
            isFinal = type.asClassOrInterfaceDeclaration().isFinal();
        }
        code.put("final", isFinal);

        // Extends / Implements
        if (type.isClassOrInterfaceDeclaration()) {
            ClassOrInterfaceDeclaration coid = type.asClassOrInterfaceDeclaration();

            // Extends
            if (!coid.getExtendedTypes().isEmpty()) {
                code.put("extends", coid.getExtendedTypes().get(0).getNameAsString());
            }

            // Implements
            if (!coid.getImplementedTypes().isEmpty()) {
                List<String> implements_ = coid.getImplementedTypes().stream()
                    .map(ClassOrInterfaceType::getNameAsString)
                    .collect(Collectors.toList());
                code.put("implements", implements_);
            }
        }

        // Members
        List<Map<String, Object>> members = new ArrayList<>();

        // Enum constants (if this is an enum)
        if (type.isEnumDeclaration()) {
            EnumDeclaration enumDecl = type.asEnumDeclaration();
            enumDecl.getEntries().forEach(entry -> {
                members.add(processEnumConstant(entry));
            });
        }

        // Methods
        type.getMethods().forEach(method -> {
            members.add(processMethod(method));
        });

        // Fields
        type.getFields().forEach(field -> {
            field.getVariables().forEach(var -> {
                members.add(processField(var, field));
            });
        });

        // Constructors
        type.getConstructors().forEach(constructor -> {
            members.add(processConstructor(constructor));
        });

        code.put("members", members);

        docset.put("code", code);

        return docset;
    }

    private static Map<String, Object> processMethod(MethodDeclaration method) {
        Map<String, Object> member = new LinkedHashMap<>();
        member.put("tagname", "method");
        member.put("name", method.getNameAsString());

        // Return type
        member.put("return_type", method.getTypeAsString());

        // Parameters
        List<Map<String, Object>> params = new ArrayList<>();
        method.getParameters().forEach(param -> {
            Map<String, Object> p = new LinkedHashMap<>();
            p.put("name", param.getNameAsString());
            p.put("type", param.getTypeAsString());
            params.add(p);
        });
        member.put("params", params);

        // Modifiers
        member.put("public", method.isPublic());
        member.put("private", method.isPrivate());
        member.put("protected", method.isProtected());
        member.put("static", method.isStatic());
        member.put("final", method.isFinal());
        member.put("abstract", method.isAbstract());

        // Javadoc
        if (method.getJavadocComment().isPresent()) {
            member.put("comment", method.getJavadocComment().get().getContent());
        }

        // Line number
        member.put("linenr", method.getBegin().map(pos -> pos.line).orElse(0));

        // Throws
        if (!method.getThrownExceptions().isEmpty()) {
            List<String> throws_ = method.getThrownExceptions().stream()
                .map(t -> t.asString())
                .collect(Collectors.toList());
            member.put("throws", throws_);
        }

        return member;
    }

    private static Map<String, Object> processField(VariableDeclarator var, FieldDeclaration field) {
        Map<String, Object> member = new LinkedHashMap<>();
        member.put("tagname", "field");
        member.put("name", var.getNameAsString());
        member.put("type", var.getTypeAsString());

        // Initial value
        if (var.getInitializer().isPresent()) {
            member.put("default", var.getInitializer().get().toString());
        }

        // Modifiers
        member.put("public", field.isPublic());
        member.put("private", field.isPrivate());
        member.put("protected", field.isProtected());
        member.put("static", field.isStatic());
        member.put("final", field.isFinal());

        // Javadoc
        if (field.getJavadocComment().isPresent()) {
            member.put("comment", field.getJavadocComment().get().getContent());
        }

        // Line number
        member.put("linenr", field.getBegin().map(pos -> pos.line).orElse(0));

        return member;
    }

    private static Map<String, Object> processConstructor(ConstructorDeclaration constructor) {
        Map<String, Object> member = new LinkedHashMap<>();
        member.put("tagname", "constructor");
        member.put("name", constructor.getNameAsString());

        // Parameters
        List<Map<String, Object>> params = new ArrayList<>();
        constructor.getParameters().forEach(param -> {
            Map<String, Object> p = new LinkedHashMap<>();
            p.put("name", param.getNameAsString());
            p.put("type", param.getTypeAsString());
            params.add(p);
        });
        member.put("params", params);

        // Modifiers
        member.put("public", constructor.isPublic());
        member.put("private", constructor.isPrivate());
        member.put("protected", constructor.isProtected());

        // Javadoc
        if (constructor.getJavadocComment().isPresent()) {
            member.put("comment", constructor.getJavadocComment().get().getContent());
        }

        // Line number
        member.put("linenr", constructor.getBegin().map(pos -> pos.line).orElse(0));

        // Throws
        if (!constructor.getThrownExceptions().isEmpty()) {
            List<String> throws_ = constructor.getThrownExceptions().stream()
                .map(t -> t.asString())
                .collect(Collectors.toList());
            member.put("throws", throws_);
        }

        return member;
    }

    private static Map<String, Object> processEnumConstant(EnumConstantDeclaration constant) {
        Map<String, Object> member = new LinkedHashMap<>();
        member.put("tagname", "enum_constant");
        member.put("name", constant.getNameAsString());

        // Javadoc
        if (constant.getJavadocComment().isPresent()) {
            member.put("comment", constant.getJavadocComment().get().getContent());
        }

        // Line number
        member.put("linenr", constant.getBegin().map(pos -> pos.line).orElse(0));

        // Arguments (if any)
        if (!constant.getArguments().isEmpty()) {
            List<String> args = constant.getArguments().stream()
                .map(arg -> arg.toString())
                .collect(Collectors.toList());
            member.put("arguments", args);
        }

        return member;
    }
}
