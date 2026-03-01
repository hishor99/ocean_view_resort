package model;

public class FoodPackage {
    private int foodId;
    private String name;
    private double pricePerDay;
    private String pricingType; // PER_ROOM_PER_DAY or PER_PERSON_PER_DAY
    private int isActive;
    private String description;

    public FoodPackage(int foodId, String name, double pricePerDay, String pricingType, int isActive, String description) {
        this.foodId = foodId;
        this.name = name;
        this.pricePerDay = pricePerDay;
        this.pricingType = pricingType;
        this.isActive = isActive;
        this.description = description;
    }

    public int getFoodId() { return foodId; }
    public String getName() { return name; }
    public double getPricePerDay() { return pricePerDay; }
    public String getPricingType() { return pricingType; }
    public int getIsActive() { return isActive; }
    public String getDescription() { return description; }
}