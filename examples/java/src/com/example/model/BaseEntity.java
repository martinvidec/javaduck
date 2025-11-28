package com.example.model;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Abstract base class for all persistent entities.
 * 
 * <p>Provides common functionality for all domain entities including
 * ID management, audit tracking, and equality/hashcode implementations.</p>
 * 
 * <p>This class implements the Auditable interface to provide
 * automatic tracking of creation and modification metadata.</p>
 * 
 * @author System Architect
 * @version 2.0
 * @since 1.0
 * @see Auditable
 */
public abstract class BaseEntity implements Auditable {
    
    /**
     * Unique identifier for this entity.
     */
    protected Long id;
    
    /**
     * Timestamp when this entity was created.
     */
    private LocalDateTime createdAt;
    
    /**
     * Username of the user who created this entity.
     */
    private String createdBy;
    
    /**
     * Timestamp of the last modification.
     */
    private LocalDateTime modifiedAt;
    
    /**
     * Username of the user who last modified this entity.
     */
    private String modifiedBy;
    
    /**
     * Constructs a new BaseEntity with automatic creation timestamp.
     */
    protected BaseEntity() {
        this.createdAt = LocalDateTime.now();
    }
    
    /**
     * Gets the unique identifier of this entity.
     * 
     * @return The ID, may be null for transient entities
     */
    public Long getId() {
        return id;
    }
    
    /**
     * Sets the unique identifier of this entity.
     * 
     * <p><strong>Warning:</strong> This should typically only be
     * called by the persistence framework.</p>
     * 
     * @param id The ID to set
     */
    public void setId(Long id) {
        this.id = id;
    }
    
    @Override
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    @Override
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String getCreatedBy() {
        return createdBy;
    }
    
    @Override
    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }
    
    @Override
    public LocalDateTime getModifiedAt() {
        return modifiedAt;
    }
    
    @Override
    public void setModifiedAt(LocalDateTime modifiedAt) {
        this.modifiedAt = modifiedAt;
    }
    
    @Override
    public String getModifiedBy() {
        return modifiedBy;
    }
    
    @Override
    public void setModifiedBy(String modifiedBy) {
        this.modifiedBy = modifiedBy;
    }
    
    /**
     * Checks if this entity has been persisted.
     * 
     * @return true if the entity has an ID, false otherwise
     */
    public boolean isPersisted() {
        return id != null;
    }
    
    /**
     * Template method for validation logic.
     * 
     * <p>Subclasses should override this method to provide
     * entity-specific validation rules.</p>
     * 
     * @throws IllegalStateException if validation fails
     */
    protected abstract void validate();
    
    /**
     * Prepares the entity for persistence.
     * 
     * <p>This method is called before saving and updates
     * the modification timestamp.</p>
     */
    protected void prePersist() {
        validate();
        if (isPersisted()) {
            this.modifiedAt = LocalDateTime.now();
        }
    }
    
    /**
     * Returns a string representation of this entity.
     * 
     * <p>Includes the class name and ID for debugging purposes.</p>
     * 
     * @return String representation
     */
    @Override
    public String toString() {
        return getClass().getSimpleName() + "{id=" + id + "}";
    }
    
    /**
     * Compares this entity with another for equality.
     * 
     * <p>Two entities are considered equal if they have the same
     * class and ID (if persisted).</p>
     * 
     * @param obj The object to compare with
     * @return true if equal, false otherwise
     */
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        BaseEntity that = (BaseEntity) obj;
        return isPersisted() && Objects.equals(id, that.id);
    }
    
    /**
     * Generates a hash code for this entity.
     * 
     * @return The hash code
     */
    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
    
    /**
     * Inner class representing entity metadata.
     * 
     * <p>This class encapsulates version information and
     * other metadata about the entity.</p>
     */
    public static class Metadata {
        private int version;
        private boolean deleted;
        
        /**
         * Gets the entity version for optimistic locking.
         * 
         * @return The version number
         */
        public int getVersion() {
            return version;
        }
        
        /**
         * Sets the entity version.
         * 
         * @param version The version number
         */
        public void setVersion(int version) {
            this.version = version;
        }
        
        /**
         * Checks if the entity is marked as deleted (soft delete).
         * 
         * @return true if deleted, false otherwise
         */
        public boolean isDeleted() {
            return deleted;
        }
        
        /**
         * Marks the entity as deleted or not deleted.
         * 
         * @param deleted true to mark as deleted
         */
        public void setDeleted(boolean deleted) {
            this.deleted = deleted;
        }
    }
}
