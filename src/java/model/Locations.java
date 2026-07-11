package model;

public class Locations {

    private int locationId;
    private String name;

    public Locations() {
    }

    public Locations(int locationId, String name) {
        this.locationId = locationId;
        this.name = name;
    }

    public int getLocationId() {
        return locationId;
    }

    public void setLocationId(int locationId) {
        this.locationId = locationId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Locations{" + "locationId=" + locationId + ", name=" + name + '}';
    }
}