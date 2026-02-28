package model;

public class Vehicle {
    private int vehicleId;
    private String type;
    private String model;
    private String plateNo;
    private double pricePerDay;
    private int capacity;
    private boolean active;
    private String notes;

    public Vehicle(int vehicleId, String type, String model, String plateNo, double pricePerDay, int capacity, boolean active, String notes) {
        this.vehicleId = vehicleId;
        this.type = type;
        this.model = model;
        this.plateNo = plateNo;
        this.pricePerDay = pricePerDay;
        this.capacity = capacity;
        this.active = active;
        this.notes = notes;
    }

    public int getVehicleId() { return vehicleId; }
    public String getType() { return type; }
    public String getModel() { return model; }
    public String getPlateNo() { return plateNo; }
    public double getPricePerDay() { return pricePerDay; }
    public int getCapacity() { return capacity; }
    public boolean isActive() { return active; }
    public String getNotes() { return notes; }
}