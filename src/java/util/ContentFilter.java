package util;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;
import java.util.regex.*;
import java.util.stream.*;

/**
 * Content filter for post-moderation system.
 * Scans text for bad words and blacklisted phone numbers.
 * Data loaded from text files in classpath.
 */
public class ContentFilter {

    private static Set<String> BAD_WORDS = new HashSet<>();
    private static Set<String> BLACKLIST_PHONES = new HashSet<>();
    private static boolean initialized = false;

    // Phone number regex (Vietnamese format)
    private static final Pattern PHONE_PATTERN = Pattern.compile("(?:0|\\+84|84)\\d{9,10}");

    static {
        reloadAll();
    }

    /**
     * Load all filter data from classpath resources.
     */
    public static synchronized void reloadAll() {
        BAD_WORDS = loadLinesFromResource("badwords.txt");
        BLACKLIST_PHONES = loadLinesFromResource("blacklist_phones.txt");
        initialized = true;
    }

    /**
     * Scan title and description for violations.
     * @return violation reason string, or null if content is clean.
     */
    public static String scan(String title, String description) {
        if (!initialized) reloadAll();

        String combined = ((title == null ? "" : title) + " " + (description == null ? "" : description)).toLowerCase();

        // Check bad words
        for (String word : BAD_WORDS) {
            if (word.isEmpty()) continue;
            if (combined.contains(word.toLowerCase())) {
                return "Noi dung chua tu ngữ khong phu hop: " + word;
            }
        }

        // Check blacklisted phone numbers
        String phonesInText = extractPhones(combined);
        if (phonesInText != null) {
            return "So dien thoai nam trong danh sach blacklist: " + phonesInText;
        }

        return null; // clean
    }

    /**
     * Check if text contains any blacklisted phone number.
     */
    public static boolean containsBlacklistedPhone(String text) {
        if (text == null || text.isEmpty()) return false;
        return extractPhones(text) != null;
    }

    /**
     * Extract and check phone numbers against blacklist.
     * @return the matched phone number, or null if none found.
     */
    private static String extractPhones(String text) {
        if (text == null) return null;
        // Normalize: remove spaces, dots, dashes from potential phone numbers
        String normalized = text.replaceAll("[\\s\\.\\-]", "");
        Matcher matcher = PHONE_PATTERN.matcher(normalized);
        while (matcher.find()) {
            String phone = normalizePhone(matcher.group());
            if (BLACKLIST_PHONES.contains(phone)) {
                return phone;
            }
        }
        return null;
    }

    /**
     * Normalize phone to format: 0xxxxxxxxx
     */
    private static String normalizePhone(String phone) {
        if (phone == null) return "";
        phone = phone.replaceAll("[^0-9]", "");
        if (phone.startsWith("84") && phone.length() >= 11) {
            phone = "0" + phone.substring(2);
        }
        return phone;
    }

    // ── Blacklist CRUD (file-based) ────────────────────────────

    /**
     * Get all blacklisted phone numbers.
     */
    public static List<String> getAllBlacklistPhones() {
        return new ArrayList<>(BLACKLIST_PHONES);
    }

    /**
     * Add a phone to blacklist and persist to file.
     */
    public static synchronized boolean addBlacklistPhone(String phone, String appRealPath) {
        String normalized = normalizePhone(phone);
        if (normalized.isEmpty()) return false;
        BLACKLIST_PHONES.add(normalized);
        return persistToFile("blacklist_phones.txt", BLACKLIST_PHONES, appRealPath);
    }

    /**
     * Remove a phone from blacklist and persist to file.
     */
    public static synchronized boolean removeBlacklistPhone(String phone, String appRealPath) {
        String normalized = normalizePhone(phone);
        BLACKLIST_PHONES.remove(normalized);
        return persistToFile("blacklist_phones.txt", BLACKLIST_PHONES, appRealPath);
    }

    // ── Bad words CRUD ────────────────────────────────────────

    public static List<String> getAllBadWords() {
        return new ArrayList<>(BAD_WORDS);
    }

    // ── File I/O helpers ──────────────────────────────────────

    private static Set<String> loadLinesFromResource(String filename) {
        Set<String> lines = new LinkedHashSet<>();
        try (InputStream is = ContentFilter.class.getClassLoader().getResourceAsStream(filename)) {
            if (is == null) {
                System.out.println("[ContentFilter] Resource not found: " + filename);
                return lines;
            }
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (!line.isEmpty() && !line.startsWith("#")) {
                        lines.add(line);
                    }
                }
            }
        } catch (IOException e) {
            System.out.println("[ContentFilter] Error loading " + filename + ": " + e.getMessage());
        }
        System.out.println("[ContentFilter] Loaded " + lines.size() + " entries from " + filename);
        return lines;
    }

    private static boolean persistToFile(String filename, Set<String> data, String appRealPath) {
        try {
            // Try to find the file in WEB-INF/classes (where classpath resources go in deployed apps)
            Path classesDir = Paths.get(appRealPath, "WEB-INF", "classes");
            Path targetFile = classesDir.resolve(filename);
            Files.createDirectories(classesDir);

            try (BufferedWriter writer = Files.newBufferedWriter(targetFile, StandardCharsets.UTF_8)) {
                writer.write("# Auto-generated by ContentFilter");
                writer.newLine();
                for (String entry : data) {
                    writer.write(entry);
                    writer.newLine();
                }
            }
            return true;
        } catch (IOException e) {
            System.out.println("[ContentFilter] Error persisting " + filename + ": " + e.getMessage());
            return false;
        }
    }
}
