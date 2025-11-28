package com.example.model;

/**
 * Base class representing a person with basic information.
 *
 * This abstract class provides common fields and methods
 * for all person-related entities in the system.
 *
 * @author Jane Smith
 * @version 1.0
 * @since 1.0
 */
public abstract class Person {

    /**
     * The person's first name.
     */
    protected String firstName;

    /**
     * The person's last name.
     */
    protected String lastName;

    /**
     * Gets the first name.
     *
     * @return The first name
     */
    public String getFirstName() {
        return firstName;
    }

    /**
     * Sets the first name.
     *
     * @param firstName The new first name
     */
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    /**
     * Gets the last name.
     *
     * @return The last name
     */
    public String getLastName() {
        return lastName;
    }

    /**
     * Sets the last name.
     *
     * @param lastName The new last name
     */
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    /**
     * Gets the full name of the person.
     *
     * @return The full name (first name + last name)
     */
    public String getFullName() {
        return firstName + " " + lastName;
    }
}
