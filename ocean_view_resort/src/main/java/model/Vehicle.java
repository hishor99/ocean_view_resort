package model;

public class Vehicle {
    private int vehicleId;
    private String type;
    private String model;
    private String plateNo;
    private double pricePerDay;
    private int capacity;
    private int isActive;
    private String notes;

    public Vehicle(int vehicleId, String type, String model, String plateNo,
                   double pricePerDay, int capacity, int isActive, String notes) {
        this.vehicleId = vehicleId;
        this.type = type;
        this.model = model;
        this.plateNo = plateNo;
        this.pricePerDay = pricePerDay;
        this.capacity = capacity;
        this.isActive = isActive;
        this.notes = notes;
    }

    public int getVehicleId() { return vehicleId; }
    public String getType() { return type; }
    public String getModel() { return model; }
    public String getPlateNo() { return plateNo; }
    public double getPricePerDay() { return pricePerDay; }
    public int getCapacity() { return capacity; }
    public int getIsActive() { return isActive; }
    public String getNotes() { return notes; }
}