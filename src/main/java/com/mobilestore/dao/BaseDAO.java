package com.mobilestore.dao;

import com.mobilestore.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Base DAO class
 * Provides common database operations for all DAOs
 */
public abstract class BaseDAO {
    
    /**
     * Get database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    protected Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }
    
    /**
     * Close database resources
     * @param conn Connection to close
     * @param stmt PreparedStatement to close
     * @param rs ResultSet to close
     */
    protected void closeResources(Connection conn, PreparedStatement stmt, ResultSet rs) {
        DBConnection.closeResource(rs);
        DBConnection.closeResource(stmt);
        DBConnection.closeConnection(conn);
    }
    
    /**
     * Close connection and statement
     * @param conn Connection to close
     * @param stmt PreparedStatement to close
     */
    protected void closeResources(Connection conn, PreparedStatement stmt) {
        closeResources(conn, stmt, null);
    }
    
    /**
     * Execute update query (INSERT, UPDATE, DELETE)
     * @param sql SQL query
     * @param params Query parameters
     * @return Number of affected rows
     * @throws SQLException if query fails
     */
    protected int executeUpdate(String sql, Object... params) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            setParameters(stmt, params);
            return stmt.executeUpdate();
        } finally {
            closeResources(conn, stmt);
        }
    }
    
    /**
     * Set parameters for PreparedStatement
     * @param stmt PreparedStatement
     * @param params Parameters to set
     * @throws SQLException if setting parameters fails
     */
    protected void setParameters(PreparedStatement stmt, Object... params) throws SQLException {
        for (int i = 0; i < params.length; i++) {
            stmt.setObject(i + 1, params[i]);
        }
    }
}
