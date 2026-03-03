package dao;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assumptions.*;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

public class VehicleDAOTest {

    @BeforeAll
    static void checkDb() throws Exception {
        TestDB.assertDbConnectionWorks();
    }

    @Test
    void testVehiclesTableHasAtLeastOneRow() throws Exception {
        Integer vehicleId = TestDB.getAnyId("vehicles", "vehicle_id");
        assumeTrue(vehicleId != null, "No vehicles found. Add at least 1 vehicle in DB.");
        assertTrue(vehicleId > 0);
    }

    /**
     * OPTIONAL if you have VehicleDAO.findAll()
     */
//    @Test
//    void testVehicleDAOFindAll_notEmpty() throws Exception {
//        VehicleDAO dao = new VehicleDAO();
//        var vehicles = dao.findAll(); // adjust method name/return type
//        assertNotNull(vehicles);
//        assertFalse(vehicles.isEmpty());
//    }
}