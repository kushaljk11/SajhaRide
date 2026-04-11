package com.riderental.myriderental.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {

    private static final String HOST = "localhost";
    private static final String PORT = "3306";
    private static final String DB_NAME = "vehicle_rental";
    private static final String USER = "root";
    private static final String PASSWORD = "";//Your Db Password

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("MySQL JDBC driver not found");
        }
    }

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(getJdbcUrl(), USER, PASSWORD);
    }

    public static void ensureDatabaseExists() throws SQLException {
        try (Connection connection = DriverManager.getConnection(getServerJdbcUrl(), USER, PASSWORD);
             Statement statement = connection.createStatement()) {
            statement.executeUpdate("CREATE DATABASE IF NOT EXISTS `" + DB_NAME + "`");
        }
    }

    public static String getJdbcUrl() {
        return getServerJdbcUrl() + DB_NAME
                + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    }

    public static String getUser() {
        return USER;
    }

    public static String getPassword() {
        return PASSWORD;
    }

    public static String getDatabaseName() {
        return DB_NAME;
    }

    private static String getServerJdbcUrl() {
        return "jdbc:mysql://" + HOST + ":" + PORT + "/";
    }
}
