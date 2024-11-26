package com.example.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {

    /**
     * Hashes a plain text password using bcrypt.
     *
     * @param plainPassword The password to hash.
     * @return The hashed password.
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }

    /**
     * Verifies the plain password against the hashed password.
     * 
     * @param plainPassword The plain text password entered by the user.
     * @param hashedPassword The hashed password stored in the database.
     * @return true if the password matches, false otherwise.
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
