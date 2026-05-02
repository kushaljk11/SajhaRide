package com.riderental.myriderental.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Utility class for managing database connections to MySQL.
 */
public class DBConnection {

    private static final String HOST = "localhost";
    private static final String PORT = "3306";
    private static final String DB_NAME = "sajharide";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("MySQL JDBC driver not found");
        }
    }

    /**
     * Private constructor to prevent instantiation of utility class.
     */
    private DBConnection() {
    }

    /**
     * Retrieves a connection to the database.
     *
     * @return a Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(getJdbcUrl(), USER, PASSWORD);
    }

    /**
     * Validates database connectivity by opening and closing a connection.
     *
     * @throws SQLException if connectivity fails
     */
    public static void validateConnectivity() throws SQLException {
        try (Connection connection = getConnection()) {
            // Opening and closing a connection is sufficient validation at startup.
        }
    }

    /**
     * Ensures the configured database exists, creating it if necessary.
     *
     * @throws SQLException if a database access error occurs
     */
    public static void ensureDatabaseExists() throws SQLException {
        try (Connection connection = DriverManager.getConnection(getServerJdbcUrl(), USER, PASSWORD);
             Statement statement = connection.createStatement()) {
            statement.executeUpdate("CREATE DATABASE IF NOT EXISTS `" + DB_NAME + "`");
        }
    }

    /**
     * Gets the JDBC URL for the database connection.
     *
     * @return the JDBC URL string
     */
    public static String getJdbcUrl() {
        return getServerJdbcUrl() + DB_NAME
                + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    }

    /**
     * Gets the database username.
     *
     * @return the username
     */
    public static String getUser() {
        return USER;
    }

    /**
     * Gets the database password.
     *
     * @return the password
     */
    public static String getPassword() {
        return PASSWORD;
    }

    /**
     * Gets the database name.
     *
     * @return the database name
     */
    public static String getDatabaseName() {
        return DB_NAME;
    }

    /**
     * Gets the server JDBC URL without the database name.
     *
     * @return the server JDBC URL string
     */
    private static String getServerJdbcUrl() {
        return "jdbc:mysql://" + HOST + ":" + PORT + "/";
    }
}
