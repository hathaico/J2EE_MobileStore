package com.mobilestore;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * Simple MobileStore Server Launcher
 * Provides a quick way to test the application locally
 */
public class ServerLauncher {

    public static void main(String[] args) {
        System.out.println("\n");
        System.out.println("====================================");
        System.out.println("  MobileStore Chatbot Server");
        System.out.println("====================================\n");

        String tomcatHome = System.getenv("TOMCAT_HOME");
        
        if (tomcatHome == null || tomcatHome.isEmpty()) {
            printManualDeploymentInstructions();
            return;
        }

        try {
            deployWAR(tomcatHome);
            startTomcat(tomcatHome);
            printAccessInfo();
        } catch (Exception e) {
            System.err.println("ERROR: Failed to start server");
            e.printStackTrace();
            printManualDeploymentInstructions();
        }
    }

    private static void deployWAR(String tomcatHome) throws Exception {
        System.out.println("[*] Deploying MobileStore.war...");
        
        File warFile = new File("target/MobileStore.war");
        if (!warFile.exists()) {
            System.out.println("[-] WAR file not found!");
            System.out.println("    Run: mvn clean package");
            throw new Exception("WAR file not found");
        }

        File webappsDir = new File(tomcatHome + "/webapps");
        if (!webappsDir.exists()) {
            System.out.println("[-] Tomcat webapps directory not found!");
            throw new Exception("Invalid TOMCAT_HOME");
        }

        // Copy WAR file
        File destWAR = new File(webappsDir, "MobileStore.war");
        Files.copy(
            Paths.get(warFile.getAbsolutePath()),
            Paths.get(destWAR.getAbsolutePath()),
            java.nio.file.StandardCopyOption.REPLACE_EXISTING
        );
        System.out.println("[+] WAR deployed successfully");
    }

    private static void startTomcat(String tomcatHome) throws Exception {
        System.out.println("[*] Starting Tomcat...");
        
        String osName = System.getProperty("os.name").toLowerCase();
        String startCommand;
        
        if (osName.contains("win")) {
            startCommand = tomcatHome + "\\bin\\startup.bat";
        } else {
            startCommand = tomcatHome + "/bin/startup.sh";
        }

        File startFile = new File(startCommand);
        if (!startFile.exists()) {
            throw new Exception("Startup script not found: " + startCommand);
        }

        ProcessBuilder pb = new ProcessBuilder(startCommand);
        pb.directory(new File(tomcatHome, "bin"));
        pb.start();
        
        System.out.println("[+] Tomcat started");
        System.out.println("[*] Waiting 10 seconds for deployment...");
        Thread.sleep(10000);
    }

    private static void printAccessInfo() {
        System.out.println("\n");
        System.out.println("====================================");
        System.out.println("  Access ChatBot at:");
        System.out.println("====================================");
        System.out.println();
        System.out.println("📚 Demo & Documentation:");
        System.out.println("   http://localhost:8080/MobileStore/chatbot-demo.html");
        System.out.println();
        System.out.println("💬 Chat Widget:");
        System.out.println("   http://localhost:8080/MobileStore/chatbot.html");
        System.out.println();
        System.out.println("🏥 API Health Check:");
        System.out.println("   http://localhost:8080/MobileStore/api/chatbot/health");
        System.out.println();
        System.out.println("====================================\n");
    }

    private static void printManualDeploymentInstructions() {
        System.out.println("[-] TOMCAT_HOME not set!");
        System.out.println();
        System.out.println("====================================");
        System.out.println("  Manual Deployment Instructions");
        System.out.println("====================================");
        System.out.println();
        System.out.println("Option 1: Set TOMCAT_HOME and run this program again:");
        System.out.println("  PowerShell: $env:TOMCAT_HOME = 'C:\\apache-tomcat-10'");
        System.out.println("  Then: java -cp target/classes com.mobilestore.ServerLauncher");
        System.out.println();
        System.out.println("Option 2: Use the provided start-server.bat script:");
        System.out.println("  1. Edit TOMCAT_HOME in start-server.bat");
        System.out.println("  2. Run: start-server.bat");
        System.out.println();
        System.out.println("Option 3: Manual deployment:");
        System.out.println("  1. Copy target/MobileStore.war to Tomcat webapps/");
        System.out.println("  2. Start Tomcat");
        System.out.println("  3. Open: http://localhost:8080/MobileStore/chatbot-demo.html");
        System.out.println();
        System.out.println("====================================\n");
    }
}
