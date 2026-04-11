package com.riderental.myriderental.config;

import com.riderental.myriderental.util.DBConnection;
import org.flywaydb.core.Flyway;

public class FlywayRunner {
    public static void migrate() {
        try {
            DBConnection.ensureDatabaseExists();
        } catch (Exception e) {
            throw new IllegalStateException("Unable to create or access database '" + DBConnection.getDatabaseName() + "'", e);
        }

        Flyway flyway = Flyway.configure()
                .baselineOnMigrate(true)
                .dataSource(DBConnection.getJdbcUrl(), DBConnection.getUser(), DBConnection.getPassword())
                .load();

        flyway.migrate();
    }
}
