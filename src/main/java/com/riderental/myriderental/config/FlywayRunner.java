package com.riderental.myriderental.config;

import com.riderental.myriderental.util.DBConnection;
import org.flywaydb.core.Flyway;

import java.util.logging.Level;
import java.util.logging.Logger;

public class FlywayRunner {

    private static final Logger LOGGER = Logger.getLogger(FlywayRunner.class.getName());

    private FlywayRunner() {
    }

    public static boolean migrate() {
        try {
            DBConnection.ensureDatabaseExists();
            DBConnection.validateConnectivity();

            Flyway flyway = Flyway.configure()
                    .baselineOnMigrate(true)
                    .locations("classpath:db/migration")
                    .dataSource(
                            DBConnection.getJdbcUrl(),
                            DBConnection.getUser(),
                            DBConnection.getPassword()
                    )
                    .load();

            flyway.migrate();
            return true;

        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Flyway migration failed for DB " + DBConnection.getJdbcUrl(), ex);
            return false;
        }
    }
}