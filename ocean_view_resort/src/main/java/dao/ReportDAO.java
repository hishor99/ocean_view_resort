package dao;

import java.sql.*;
import java.util.*;

public class ReportDAO {

    // Reservations per month
    public Map<String,Integer> getReservationsPerMonth(int year) throws Exception {

        Map<String,Integer> data = new LinkedHashMap<>();

        String sql =
        "SELECT MONTH(check_in) month, COUNT(*) total " +
        "FROM reservations " +
        "WHERE YEAR(check_in)=? " +
        "GROUP BY MONTH(check_in)";

        try(Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){

            ps.setInt(1, year);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                data.put("Month "+rs.getInt("month"), rs.getInt("total"));
            }
        }

        return data;
    }


    // Reservations by status
    public Map<String,Integer> getReservationsByStatus() throws Exception {

        Map<String,Integer> data = new LinkedHashMap<>();

        String sql =
        "SELECT status, COUNT(*) total FROM reservations GROUP BY status";

        try(Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                data.put(rs.getString("status"), rs.getInt("total"));
            }
        }

        return data;
    }


    // Revenue per month
    public Map<String,Double> getRevenuePerMonth(int year) throws Exception {

        Map<String,Double> data = new LinkedHashMap<>();

        String sql =
        "SELECT MONTH(check_in) month, SUM(grand_total) revenue " +
        "FROM reservations " +
        "WHERE YEAR(check_in)=? AND status IN ('CONFIRMED','COMPLETED') " +
        "GROUP BY MONTH(check_in)";

        try(Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){

            ps.setInt(1, year);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                data.put("Month "+rs.getInt("month"), rs.getDouble("revenue"));
            }
        }

        return data;
    }

}