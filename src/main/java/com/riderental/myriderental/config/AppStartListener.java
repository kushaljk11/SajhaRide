package com.riderental.myriderental.config;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.lang.reflect.Method;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebListener
public class AppStartListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(AppStartListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        String jdbcUrl = com.riderental.myriderental.util.DBConnection.getJdbcUrl();
        try {
            context.log("Starting application initialization. Validating DB and running Flyway migrations. JDBC URL=" + jdbcUrl);
            FlywayRunner.migrate();
            context.log("Flyway migration completed.");
        } catch (Throwable ex) {
            Throwable rootCause = getRootCause(ex);
            context.log("Application startup failed in AppStartListener.contextInitialized. Root cause: "
                    + rootCause.getClass().getName() + ": " + rootCause.getMessage(), ex);
            LOGGER.log(Level.SEVERE, "Startup failed for JDBC URL " + jdbcUrl, ex);
            throw ex;
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        cleanupJdbcDrivers();
        shutdownMysqlCleanupThread();
    }

    private void cleanupJdbcDrivers() {
        ClassLoader webAppClassLoader = AppStartListener.class.getClassLoader();
        Enumeration<Driver> drivers = DriverManager.getDrivers();

        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            if (driver.getClass().getClassLoader() == webAppClassLoader) {
                try {
                    DriverManager.deregisterDriver(driver);
                } catch (SQLException ex) {
                    LOGGER.log(Level.FINE, "Could not deregister JDBC driver during shutdown: " + driver, ex);
                }
            }
        }
    }

    private void shutdownMysqlCleanupThread() {
        try {
            Class<?> cleanupThreadClass = Class.forName("com.mysql.cj.jdbc.AbandonedConnectionCleanupThread");
            Method checkedShutdown = cleanupThreadClass.getMethod("checkedShutdown");
            checkedShutdown.invoke(null);
        } catch (ClassNotFoundException ignored) {
            // MySQL driver not present in this classloader; nothing to shut down.
        } catch (Exception ex) {
            LOGGER.log(Level.FINE, "MySQL cleanup thread shutdown was not completed.", ex);
        }
    }

    private Throwable getRootCause(Throwable throwable) {
        Throwable cursor = throwable;
        while (cursor.getCause() != null && cursor.getCause() != cursor) {
            cursor = cursor.getCause();
        }
        return cursor;
    }
}