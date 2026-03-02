package model;

public class Vehicle {

    private int vehicleId;
    private String type;
    private String model;
    private String plateNo;
    private double pricePerDay;
    private int capacity;
    private int isActive;   // 1 = active, 0 = inactive
    private String notes;

    // ✅ Empty constructor
    public Vehicle() {}

    // ✅ Main constructor (used by DAO)
    public Vehicle(int vehicleId, String type, String model, String plateNo,
                   double pricePerDay, int capacity, int isActive, String notes) {
        this.vehicleId = vehicleId;
        this.type = type;
        this.model = model;
        this.plateNo = plateNo;
        this.pricePerDay = pricePerDay;
        this.capacity = capacity;
        this.isActive = (isActive == 1) ? 1 : 0; // normalize
        this.notes = notes;
    }

    // ===== Getters =====
    public int getVehicleId() { return vehicleId; }
    public String getType() { return type; }
    public String getModel() { return model; }
    public String getPlateNo() { return plateNo; }
    public double getPricePerDay() { return pricePerDay; }
    public int getCapacity() { return capacity; }
    public int getIsActive() { return isActive; }
    public String getNotes() { return notes; }

    // ✅ NEW: Boolean helper for JSP (v.isActive())
    public boolean isActive() {
        return isActive == 1;
    }

    // ===== Setters =====
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }
    public void setType(String type) { this.type = type; }
    public void setModel(String model) { this.model = model; }
    public void setPlateNo(String plateNo) { this.plateNo = plateNo; }
    public void setPricePerDay(double pricePerDay) { this.pricePerDay = pricePerDay; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    // ✅ Normalize setter (ensures only 0 or 1 stored)
    public void setIsActive(int isActive) {
        this.isActive = (isActive == 1) ? 1 : 0;
    }

    public void setNotes(String notes) { this.notes = notes; }
}