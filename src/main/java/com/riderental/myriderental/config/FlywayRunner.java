package com.riderental.myriderental.config;

import com.riderental.myriderental.util.DBConnection;
import org.flywaydb.core.Flyway;
import org.flywaydb.core.api.FlywayException;

import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FlywayRunner {

    private static final Logger LOGGER = Logger.getLogger(FlywayRunner.class.getName());

    public static void migrate() {
        try {
            DBConnection.ensureDatabaseExists();
            DBConnection.validateConnectivity();
        } catch (SQLException e) {
            throw new IllegalStateException("Unable to create/access/validate database '" + DBConnection.getDatabaseName() + "' at "
                    + DBConnection.getJdbcUrl() + ". SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode(), e);
        }

        Flyway flyway = Flyway.configure()
                .baselineOnMigrate(true)
                .locations("classpath:db/migration")
                .dataSource(DBConnection.getJdbcUrl(), DBConnection.getUser(), DBConnection.getPassword())
                .load();

        try {
            flyway.migrate();
        } catch (FlywayException e) {
            LOGGER.log(Level.SEVERE, "Flyway migration failed for DB " + DBConnection.getJdbcUrl(), e);
            throw e;
        }
    }
}
