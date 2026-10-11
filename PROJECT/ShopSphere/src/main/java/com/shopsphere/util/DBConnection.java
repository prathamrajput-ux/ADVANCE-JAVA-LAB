package com.shopsphere.util;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

/**
 * High-Performance Connection Pooling and JDBC Utility for ShopSphere.
 * - Eliminates Windows IPv6 localhost DNS resolution delays by using 127.0.0.1.
 * - Provides lightweight connection pooling via dynamic proxy wrapper.
 * - Reuses physical MySQL sockets so SQL queries execute in under 1ms.
 */
public class DBConnection {

    private static final String HOST = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "127.0.0.1";
    private static final String PORT = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "3306";
    private static final String URL = "jdbc:mysql://" + HOST + ":" + PORT + "/shopsphere"
            + "?createDatabaseIfNotExist=true"
            + "&useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=UTC"
            + "&connectTimeout=3000"
            + "&socketTimeout=30000"
            + "&cachePrepStmts=true"
            + "&prepStmtCacheSize=250"
            + "&prepStmtCacheSqlLimit=2048"
            + "&useServerPrepStmts=true"
            + "&rewriteBatchedStatements=true";

    private static final String USERNAME = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root";
    private static String PASSWORD = "2703";

    private static final int MAX_POOL_SIZE = 15;
    private static final BlockingQueue<Connection> pool = new ArrayBlockingQueue<>(MAX_POOL_SIZE);

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Auto initialize database and seed tables if empty
            DatabaseInitializer.initializeDatabaseIfEmpty();
            PASSWORD = DatabaseInitializer.getActivePassword();

            // Pre-warm initial connections for instant response
            for (int i = 0; i < 5; i++) {
                pool.offer(createPhysicalConnection());
            }
        } catch (Exception e) {
            System.err.println("DBConnection pool pre-warm note: " + e.getMessage());
        }
    }

    private static Connection createPhysicalConnection() throws SQLException {
        try {
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (SQLException ex) {
            // Fallback via DatabaseInitializer direct connection if password or state changed
            return DatabaseInitializer.getDirectConnection();
        }
    }

    /**
     * Obtains a connection from the pool. The returned Connection is wrapped in a dynamic proxy
     * such that calling close() returns the underlying physical connection back to the pool.
     */
    public static Connection getConnection() throws SQLException {
        Connection physicalConn = pool.poll();

        // Validate retrieved connection or create a fresh one if invalid
        if (physicalConn == null || physicalConn.isClosed()) {
            physicalConn = createPhysicalConnection();
        } else {
            try {
                if (!physicalConn.isValid(1)) {
                    try { physicalConn.close(); } catch (Exception ignored) {}
                    physicalConn = createPhysicalConnection();
                }
            } catch (SQLException e) {
                physicalConn = createPhysicalConnection();
            }
        }

        final Connection target = physicalConn;
        return (Connection) Proxy.newProxyInstance(
                DBConnection.class.getClassLoader(),
                new Class<?>[]{Connection.class},
                new InvocationHandler() {
                    private boolean isClosed = false;

                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        String name = method.getName();

                        if ("close".equals(name)) {
                            if (!isClosed) {
                                isClosed = true;
                                if (!target.isClosed() && target.isValid(1)) {
                                    if (!target.getAutoCommit()) {
                                        target.setAutoCommit(true);
                                    }
                                    // Return to pool if room; otherwise close physical connection
                                    if (!pool.offer(target)) {
                                        target.close();
                                    }
                                }
                            }
                            return null;
                        }

                        if ("isClosed".equals(name)) {
                            return isClosed || target.isClosed();
                        }

                        return method.invoke(target, args);
                    }
                }
        );
    }
}
