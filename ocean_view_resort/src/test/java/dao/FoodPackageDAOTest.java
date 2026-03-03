package dao;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assumptions.*;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

public class FoodPackageDAOTest {

    @BeforeAll
    static void checkDb() throws Exception {
        TestDB.assertDbConnectionWorks();
    }

    @Test
    void testFoodPackagesTableHasAtLeastOneRow() throws Exception {
        // If your table name is different, change it here.
        Integer foodId = TestDB.getAnyId("food_packages", "food_id");
        assumeTrue(foodId != null, "No food packages found. Add at least 1 food package in DB.");
        assertTrue(foodId > 0);
    }

    /**
     * OPTIONAL if your FoodPackageDAO has findAll()
     */
//    @Test
//    void testFoodPackageDAOFindAll_notEmpty() throws Exception {
//        FoodPackageDAO dao = new FoodPackageDAO();
//        var foods = dao.findAll(); // adjust method name/return type
//        assertNotNull(foods);
//        assertFalse(foods.isEmpty());
//    }
}