package com.riderental.myriderental.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Small JDBC helper to reduce repeated query boilerplate in DAOs.
 */
public final class DaoHelper {

    private DaoHelper() {
    }

    public static <T> T queryOne(String sql, SqlFunction<ResultSet, T> mapper) throws SQLException {
        return queryOne(sql, stmt -> { }, mapper);
    }

    public static <T> T queryOne(String sql, SqlConsumer<PreparedStatement> binder,
                                 SqlFunction<ResultSet, T> mapper) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            binder.accept(stmt);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapper.apply(rs);
                }
            }
        }
        return null;
    }

    public static <T> List<T> queryList(String sql, SqlFunction<ResultSet, T> mapper) throws SQLException {
        return queryList(sql, stmt -> { }, mapper);
    }

    public static <T> List<T> queryList(String sql, SqlConsumer<PreparedStatement> binder,
                                        SqlFunction<ResultSet, T> mapper) throws SQLException {
        List<T> results = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            binder.accept(stmt);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    results.add(mapper.apply(rs));
                }
            }
        }
        return results;
    }

    public static int queryCount(String sql, SqlConsumer<PreparedStatement> binder) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            binder.accept(stmt);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public static int queryCount(String sql) throws SQLException {
        return queryCount(sql, stmt -> { });
    }

    public static double queryDouble(String sql, SqlConsumer<PreparedStatement> binder) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            binder.accept(stmt);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }
        return 0;
    }

    public static double queryDouble(String sql) throws SQLException {
        return queryDouble(sql, stmt -> { });
    }

    public static int executeUpdate(String sql, SqlConsumer<PreparedStatement> binder) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            binder.accept(stmt);
            return stmt.executeUpdate();
        }
    }

    @FunctionalInterface
    public interface SqlConsumer<T> {
        void accept(T value) throws SQLException;
    }

    @FunctionalInterface
    public interface SqlFunction<T, R> {
        R apply(T value) throws SQLException;
    }
}
