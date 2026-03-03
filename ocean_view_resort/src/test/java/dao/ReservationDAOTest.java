package dao;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assumptions.*;

import java.time.LocalDate;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

public class ReservationDAOTest {

    @BeforeAll
    static void checkDb() throws Exception {
        TestDB.assertDbConnectionWorks();
    }

    @Test
    void testCreateReservation_insertsRowAndReturnsGeneratedId() throws Exception {
        ReservationDAO dao = new ReservationDAO();

        Integer customerId = TestDB.getAnyCustomerId();
        Integer roomId = TestDB.getAnyId("rooms", "room_id");

        // If these are null, your DB has no seed data -> add at least 1 customer + 1 room.
        assumeTrue(customerId != null, "No customer found in users table");
        assumeTrue(roomId != null, "No room found in rooms table");

        LocalDate checkIn = LocalDate.now().plusDays(1);
        LocalDate checkOut = LocalDate.now().plusDays(3);

        int reservationId = dao.createReservation(
                customerId,
                roomId,
                checkIn,
                checkOut,
                2,          // nights
                2,          // guests
                null,       // foodId
                null,       // vehicleId
                20000.0,    // roomTotal
                0.0,        // foodTotal
                0.0,        // vehicleTotal
                20000.0     // grandTotal
        );

        assertTrue(reservationId > 0, "ReservationDAO should return generated reservation ID");
        assertTrue(TestDB.existsById("reservations", "reservation_id", reservationId),
                "Inserted reservation row should exist in DB");

        // cleanup
        TestDB.deleteById("reservations", "reservation_id", reservationId);
        assertFalse(TestDB.existsById("reservations", "reservation_id", reservationId),
                "Reservation should be deleted in cleanup");
    }
}