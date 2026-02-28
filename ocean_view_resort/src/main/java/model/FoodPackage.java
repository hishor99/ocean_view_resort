package model;

public class FoodPackage {
    private int foodId;
    private String name;
    private double pricePerDay;
    private String pricingType;
    private boolean active;
    private String description;

    public FoodPackage(int foodId, String name, double pricePerDay, String pricingType, boolean active, String description) {
        this.foodId = foodId;
        this.name = name;
        this.pricePerDay = pricePerDay;
        this.pricingType = pricingType;
        this.active = active;
        this.description = description;
    }

    public int getFoodId() { return foodId; }
    public String getName() { return name; }
    public double getPricePerDay() { return pricePerDay; }
    public String getPricingType() { return pricingType; }
    public boolean isActive() { return active; }
    public String getDescription() { return description; }
}