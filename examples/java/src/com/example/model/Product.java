package com.example.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Represents a product in the inventory system.
 * 
 * <p>Products can have multiple variants (SKUs), pricing information,
 * and category associations. This class demonstrates the use of
 * inheritance, annotations, and various access modifiers.</p>
 * 
 * @author Product Team
 * @version 3.0
 * @since 2.0
 * @see BaseEntity
 * @see Category
 */
public class Product extends BaseEntity {
    
    /**
     * Product name.
     */
    private String name;
    
    /**
     * Product description (may contain HTML).
     */
    private String description;
    
    /**
     * Current price of the product.
     */
    private BigDecimal price;
    
    /**
     * Stock keeping unit identifier.
     */
    private String sku;
    
    /**
     * Category this product belongs to.
     */
    private Category category;
    
    /**
     * List of product variants.
     */
    private List<ProductVariant> variants;
    
    /**
     * Whether this product is currently active.
     */
    private boolean active;
    
    /**
     * Creates a new Product with default values.
     */
    public Product() {
        super();
        this.variants = new ArrayList<>();
        this.active = true;
    }
    
    /**
     * Creates a new Product with the specified name and price.
     * 
     * @param name The product name
     * @param price The product price
     */
    public Product(String name, BigDecimal price) {
        this();
        this.name = name;
        this.price = price;
    }
    
    /**
     * Gets the product name.
     * 
     * @return The product name
     */
    public String getName() {
        return name;
    }
    
    /**
     * Sets the product name.
     * 
     * @param name The product name (must not be null or empty)
     * @throws IllegalArgumentException if name is invalid
     */
    public void setName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Product name cannot be null or empty");
        }
        this.name = name;
    }
    
    /**
     * Gets the product description.
     * 
     * @return The description, may be null
     */
    public String getDescription() {
        return description;
    }
    
    /**
     * Sets the product description.
     * 
     * @param description The description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * Gets the product price.
     * 
     * @return The price
     */
    public BigDecimal getPrice() {
        return price;
    }
    
    /**
     * Sets the product price.
     * 
     * @param price The price (must be positive)
     * @throws IllegalArgumentException if price is negative
     */
    public void setPrice(BigDecimal price) {
        validatePrice(price);
        this.price = price;
    }
    
    /**
     * Gets the SKU (Stock Keeping Unit).
     * 
     * @return The SKU
     */
    public String getSku() {
        return sku;
    }
    
    /**
     * Sets the SKU.
     * 
     * @param sku The SKU
     */
    public void setSku(String sku) {
        this.sku = sku;
    }
    
    /**
     * Gets the product category.
     * 
     * @return The category, may be null
     */
    public Category getCategory() {
        return category;
    }
    
    /**
     * Sets the product category.
     * 
     * @param category The category
     */
    public void setCategory(Category category) {
        this.category = category;
    }
    
    /**
     * Gets the list of product variants.
     * 
     * @return Unmodifiable list of variants
     */
    public List<ProductVariant> getVariants() {
        return new ArrayList<>(variants);
    }
    
    /**
     * Adds a product variant.
     * 
     * @param variant The variant to add
     */
    public void addVariant(ProductVariant variant) {
        if (variant != null) {
            variants.add(variant);
        }
    }
    
    /**
     * Checks if the product is active.
     * 
     * @return true if active
     */
    public boolean isActive() {
        return active;
    }
    
    /**
     * Sets the product active status.
     * 
     * @param active true to activate, false to deactivate
     */
    public void setActive(boolean active) {
        this.active = active;
    }
    
    /**
     * Validates the product state.
     * 
     * @throws IllegalStateException if validation fails
     */
    @Override
    protected void validate() {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalStateException("Product must have a name");
        }
        if (price == null) {
            throw new IllegalStateException("Product must have a price");
        }
        validatePrice(price);
    }
    
    /**
     * Validates the price value.
     * 
     * @param price The price to validate
     * @throws IllegalArgumentException if price is invalid
     */
    private void validatePrice(BigDecimal price) {
        if (price != null && price.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
    }
    
    /**
     * Calculates the discounted price.
     * 
     * @param discountPercent The discount percentage (0-100)
     * @return The discounted price
     * @throws IllegalArgumentException if discount is invalid
     */
    public BigDecimal calculateDiscountedPrice(double discountPercent) {
        if (discountPercent < 0 || discountPercent > 100) {
            throw new IllegalArgumentException("Discount must be between 0 and 100");
        }
        BigDecimal discount = BigDecimal.valueOf(discountPercent / 100);
        return price.multiply(BigDecimal.ONE.subtract(discount));
    }
    
    /**
     * Formats the price for display.
     * 
     * @return Formatted price string
     * @deprecated Use a dedicated PriceFormatter instead
     */
    @Deprecated
    protected String formatPrice() {
        return "$" + price.toString();
    }
    
    /**
     * Inner class representing a product variant.
     * 
     * <p>Variants allow a single product to have multiple options
     * such as different sizes or colors.</p>
     */
    public static class ProductVariant {
        private String name;
        private String value;
        private BigDecimal priceAdjustment;
        
        /**
         * Creates a new product variant.
         * 
         * @param name The variant name (e.g., "Size", "Color")
         * @param value The variant value (e.g., "Large", "Red")
         */
        public ProductVariant(String name, String value) {
            this.name = name;
            this.value = value;
            this.priceAdjustment = BigDecimal.ZERO;
        }
        
        /**
         * Gets the variant name.
         * 
         * @return The name
         */
        public String getName() {
            return name;
        }
        
        /**
         * Gets the variant value.
         * 
         * @return The value
         */
        public String getValue() {
            return value;
        }
        
        /**
         * Gets the price adjustment for this variant.
         * 
         * @return The price adjustment (can be negative)
         */
        public BigDecimal getPriceAdjustment() {
            return priceAdjustment;
        }
        
        /**
         * Sets the price adjustment.
         * 
         * @param priceAdjustment The price adjustment
         */
        public void setPriceAdjustment(BigDecimal priceAdjustment) {
            this.priceAdjustment = priceAdjustment;
        }
    }
    
    /**
     * Enum representing product status.
     */
    public enum ProductStatus {
        /**
         * Product is a draft and not yet published.
         */
        DRAFT,
        
        /**
         * Product is published and visible to customers.
         */
        PUBLISHED,
        
        /**
         * Product is archived and no longer available.
         */
        ARCHIVED
    }
}
