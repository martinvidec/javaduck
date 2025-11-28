package com.example;

import java.util.List;
import java.io.IOException;

/**
 * A sample Java class for integration testing.
 *
 * @author John Doe <john@example.com>
 * @version 1.0
 * @since 1.0
 */
public class SampleClass extends BaseClass implements Runnable {

    /**
     * The name field.
     */
    private String name;

    /**
     * The count field with default value.
     */
    private int count = 0;

    /**
     * Creates a new SampleClass.
     *
     * @param name The name
     */
    public SampleClass(String name) {
        this.name = name;
    }

    /**
     * Gets the name.
     *
     * @return The name value
     */
    public String getName() {
        return this.name;
    }

    /**
     * Sets the name.
     *
     * @param name The new name
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Process data with error handling.
     *
     * @param items The list of items to process
     * @param maxCount Maximum items to process
     * @return Number of processed items
     * @throws IOException If an I/O error occurs
     */
    public int processData(List<String> items, int maxCount) throws IOException {
        // Implementation
        return 0;
    }

    /**
     * Implementation of Runnable interface.
     */
    @Override
    public void run() {
        // Implementation
    }
}
