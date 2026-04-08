package com.riderental.myriderental.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("MySQL JDBC driver not found");
        }
    }

    private static final String HOST = "localhost";
    private static final String PORT = "3306";
    private static final String DB_NAME = "vehicle_rental";
    private static final String USER = "root";
    private static final String PASSWORD = "";//Your DB Password

    private static final String BASE_URL =
            "jdbc:mysql://" + HOST + ":" + PORT + "/";

    private static boolean schemaInitialized = false;


        public static Connection getConnection() throws SQLException {
            if (!schemaInitialized) {
                synchronized (DBConnection.class) {
                    if (!schemaInitialized) {
                        try (Connection connection =
                                     DriverManager.getConnection(BASE_URL, USER, PASSWORD)) {
                            runSqlFile(connection, "Schema.sql");
                        }

                        try (Connection connection =
                                     DriverManager.getConnection(BASE_URL + DB_NAME, USER, PASSWORD)) {
                            runSqlFile(connection, "updates.sql");
                        }
                        schemaInitialized = true;
                    }
                }
            }

            return DriverManager.getConnection(BASE_URL + DB_NAME, USER, PASSWORD);
        }


        private static void runSqlFile(Connection connection, String fileName) throws SQLException {

            try (InputStream input =
                         DBConnection.class.getClassLoader().getResourceAsStream(fileName)) {

                if (input == null) return;

                String sql = new String(input.readAllBytes());

                try (Statement statement = connection.createStatement()) {

                    for (String query : sql.split(";")) {

                        String trimmed = query.trim();

                        if (!trimmed.isEmpty()) {
                            try {
                                statement.execute(trimmed);
                            } catch (SQLException ignored) {
                            }
                        }
                    }
                }

            } catch (Exception e) {
                throw new SQLException(e);
            }
        }
    }
