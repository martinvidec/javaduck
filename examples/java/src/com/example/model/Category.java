package com.example.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Represents a product category in a hierarchical structure.
 * 
 * <p>Categories can have parent-child relationships allowing
 * for nested categorization of products.</p>
 * 
 * @author Product Team
 * @version 1.0
 * @since 2.0
 */
public class Category extends BaseEntity {
    
    private String name;
    private String slug;
    private Category parent;
    private List<Category> children;
    
    /**
     * Creates a new Category.
     */
    public Category() {
        super();
        this.children = new ArrayList<>();
    }
    
    /**
     * Creates a new Category with a name.
     * 
     * @param name The category name
     */
    public Category(String name) {
        this();
        this.name = name;
        this.slug = generateSlug(name);
    }
    
    /**
     * Gets the category name.
     * 
     * @return The name
     */
    public String getName() {
        return name;
    }
    
    /**
     * Sets the category name.
     * 
     * @param name The name
     */
    public void setName(String name) {
        this.name = name;
        this.slug = generateSlug(name);
    }
    
    /**
     * Gets the URL-friendly slug.
     * 
     * @return The slug
     */
    public String getSlug() {
        return slug;
    }
    
    /**
     * Gets the parent category.
     * 
     * @return The parent, or null if this is a root category
     */
    public Category getParent() {
        return parent;
    }
    
    /**
     * Sets the parent category.
     * 
     * @param parent The parent category
     */
    public void setParent(Category parent) {
        this.parent = parent;
        if (parent != null && !parent.children.contains(this)) {
            parent.children.add(this);
        }
    }
    
    /**
     * Gets the child categories.
     * 
     * @return List of children
     */
    public List<Category> getChildren() {
        return new ArrayList<>(children);
    }
    
    /**
     * Checks if this is a root category.
     * 
     * @return true if no parent
     */
    public boolean isRoot() {
        return parent == null;
    }
    
    /**
     * Validates the category.
     */
    @Override
    protected void validate() {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalStateException("Category must have a name");
        }
    }
    
    /**
     * Generates a URL-friendly slug from the name.
     * 
     * @param name The name to slugify
     * @return The slug
     */
    private String generateSlug(String name) {
        if (name == null) return null;
        return name.toLowerCase()
                   .replaceAll("[^a-z0-9]+", "-")
                   .replaceAll("^-|-$", "");
    }
}
