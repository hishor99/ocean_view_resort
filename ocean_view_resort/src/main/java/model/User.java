package model;

public class User {   // ✅ Capital U

    private int userId;
    private String fullName;
    private String role;
    private String status;

    public User(int userId, String fullName, String role, String status) {
        this.userId = userId;
        this.fullName = fullName;
        this.role = role;
        this.status = status;
    }

    public int getUserId() {
        return userId;
    }

    public String getFullName() {
        return fullName;
    }

    public String getRole() {
        return role;
    }

    public String getStatus() {
        return status;
    }
}