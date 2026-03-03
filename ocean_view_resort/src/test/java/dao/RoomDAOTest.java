package dao;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assumptions.*;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

public class RoomDAOTest {

    @BeforeAll
    static void checkDb() throws Exception {
        TestDB.assertDbConnectionWorks();
    }

    @Test
    void testRoomsTableHasAtLeastOneRow() throws Exception {
        Integer roomId = TestDB.getAnyId("rooms", "room_id");
        assumeTrue(roomId != null, "No rooms found. Add at least 1 room in DB.");
        assertTrue(roomId > 0);
    }

    /**
     * OPTIONAL: If your RoomDAO has findAll(), uncomment and adjust return type.
     *
     * Example signatures:
     *   List<Room> findAll()
     *   List<Map<String,Object>> findAllRooms()
     */
//    @Test
//    void testRoomDAOFindAll_notEmpty() throws Exception {
//        RoomDAO dao = new RoomDAO();
//        var rooms = dao.findAll(); // adjust method name
//        assertNotNull(rooms);
//        assertFalse(rooms.isEmpty());
//    }
}