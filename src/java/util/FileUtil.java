package util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

public class FileUtil {

    public static void saveUploadedFile(Part part, String savedName, ServletContext context, String folderName) throws IOException {
        // 1. Save to deployed (running) directory
        String deployRoot = context.getRealPath("/");
        if (deployRoot != null) {
            Path deployDir = Paths.get(deployRoot).resolve(folderName);
            Files.createDirectories(deployDir);
            Path deployFile = deployDir.resolve(savedName);
            try (InputStream in = part.getInputStream()) {
                Files.copy(in, deployFile, StandardCopyOption.REPLACE_EXISTING);
            }
        }

        // 2. Save to source directory (to persist on clean/build)
        if (deployRoot != null) {
            // Replace build\web and build/web with web
            String sourceRoot = deployRoot.replace("build\\web", "web").replace("build/web", "web");
            
            // Check if source folder exists
            Path sourceDir = Paths.get(sourceRoot).resolve(folderName);
            if (Files.exists(Paths.get(sourceRoot))) {
                Files.createDirectories(sourceDir);
                Path sourceFile = sourceDir.resolve(savedName);
                try (InputStream in = part.getInputStream()) {
                    Files.copy(in, sourceFile, StandardCopyOption.REPLACE_EXISTING);
                }
            }
        }
    }

    public static void deleteFile(String relativePath, ServletContext context) {
        if (relativePath == null || relativePath.trim().isEmpty()) {
            return;
        }
        String appRoot = context.getRealPath("/");
        if (appRoot == null) {
            return;
        }

        // Delete from deploy directory
        try {
            Path filePath = Paths.get(appRoot).resolve(relativePath.replace("/", "\\")).normalize();
            Files.deleteIfExists(filePath);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Delete from source directory
        try {
            String sourceRoot = appRoot.replace("build\\web", "web").replace("build/web", "web");
            if (Files.exists(Paths.get(sourceRoot))) {
                Path filePath = Paths.get(sourceRoot).resolve(relativePath.replace("/", "\\")).normalize();
                Files.deleteIfExists(filePath);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
