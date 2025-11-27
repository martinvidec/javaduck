package com.example.test;

import java.util.List;

/**
 * A simple test class to demonstrate JavaParser capabilities.
 *
 * @author Martin Videc
 * @version 1.0.0
 * @since 2025-11-27
 */
public class TestClass extends BaseClass implements Runnable, Comparable<TestClass> {

    /**
     * A public constant field.
     */
    public static final int MAX_SIZE = 100;

    /**
     * A private instance field with initial value.
     */
    private String name = "default";

    /**
     * Counter field.
     */
    private int count;

    /**
     * Default constructor.
     * Creates a new TestClass instance.
     */
    public TestClass() {
        this.count = 0;
    }

    /**
     * Constructor with name parameter.
     *
     * @param name the name to set
     */
    public TestClass(String name) {
        this.name = name;
        this.count = 0;
    }

    /**
     * Gets the name of this instance.
     *
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the name.
     *
     * @param name the new name
     * @throws IllegalArgumentException if name is null
     */
    public void setName(String name) throws IllegalArgumentException {
        if (name == null) {
            throw new IllegalArgumentException("Name cannot be null");
        }
        this.name = name;
    }

    /**
     * Increments the counter.
     */
    public void increment() {
        count++;
    }

    /**
     * Gets the current count.
     *
     * @return current count value
     */
    public int getCount() {
        return count;
    }

    /**
     * Static utility method.
     *
     * @param items the list of items
     * @return the size of the list
     */
    public static int getSize(List<?> items) {
        return items != null ? items.size() : 0;
    }

    /**
     * Abstract method implementation from Runnable.
     *
     * @see Runnable#run()
     */
    @Override
    public void run() {
        System.out.println("Running: " + name);
    }

    /**
     * Compares this object with another TestClass.
     *
     * @param other the other TestClass
     * @return comparison result
     */
    @Override
    public int compareTo(TestClass other) {
        return this.name.compareTo(other.name);
    }

    /**
     * Abstract base class for testing inheritance.
     */
    static abstract class BaseClass {
        /**
         * Abstract method to be implemented.
         */
        public abstract void doSomething();
    }
}
