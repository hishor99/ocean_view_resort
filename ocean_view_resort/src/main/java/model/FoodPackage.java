package model;

public class FoodPackage {

    private int foodId;
    private String name;
    private double pricePerDay;
    private String pricingType; // PER_ROOM_PER_DAY or PER_PERSON_PER_DAY
    private int isActive;       // 1 = active, 0 = inactive
    private String description;

    // ✅ Empty constructor (optional)
    public FoodPackage() {}

    // ✅ Main constructor (used by DAO)
    public FoodPackage(int foodId, String name, double pricePerDay,
                       String pricingType, int isActive, String description) {
        this.foodId = foodId;
        this.name = name;
        this.pricePerDay = pricePerDay;
        this.pricingType = pricingType;
        this.isActive = (isActive == 1) ? 1 : 0; // normalize
        this.description = description;
    }

    // ===== Getters =====
    public int getFoodId() { return foodId; }
    public String getName() { return name; }
    public double getPricePerDay() { return pricePerDay; }
    public String getPricingType() { return pricingType; }

    // ✅ Keep int getter (useful for DB/forms)
    public int getIsActive() { return isActive; }

    public String getDescription() { return description; }

    // ✅ NEW: boolean getter for JSP usage (f.isActive())
    public boolean isActive() {
        return isActive == 1;
    }

    // ===== Setters =====
    public void setFoodId(int foodId) { this.foodId = foodId; }
    public void setName(String name) { this.name = name; }
    public void setPricePerDay(double pricePerDay) { this.pricePerDay = pricePerDay; }
    public void setPricingType(String pricingType) { this.pricingType = pricingType; }

    // ✅ Normalized setter (ensures only 0/1 stored)
    public void setIsActive(int isActive) {
        this.isActive = (isActive == 1) ? 1 : 0;
    }

    public void setDescription(String description) { this.description = description; }
}