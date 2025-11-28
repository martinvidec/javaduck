package com.example.model;

import java.time.LocalDateTime;

/**
 * Interface for entities that support audit tracking.
 * 
 * <p>Implementing this interface allows entities to track creation
 * and modification timestamps along with the users who performed
 * these actions.</p>
 * 
 * @author System Architect
 * @version 1.0
 * @since 1.5
 * @see BaseEntity
 */
public interface Auditable {
    
    /**
     * Gets the timestamp when this entity was created.
     * 
     * @return The creation timestamp, never null
     */
    LocalDateTime getCreatedAt();
    
    /**
     * Sets the creation timestamp.
     * 
     * @param createdAt The creation timestamp
     */
    void setCreatedAt(LocalDateTime createdAt);
    
    /**
     * Gets the username of the user who created this entity.
     * 
     * @return The creator's username, may be null
     */
    String getCreatedBy();
    
    /**
     * Sets the creator's username.
     * 
     * @param createdBy The username
     */
    void setCreatedBy(String createdBy);
    
    /**
     * Gets the timestamp of the last modification.
     * 
     * @return The last modification timestamp, may be null if never modified
     */
    LocalDateTime getModifiedAt();
    
    /**
     * Sets the last modification timestamp.
     * 
     * @param modifiedAt The modification timestamp
     */
    void setModifiedAt(LocalDateTime modifiedAt);
    
    /**
     * Gets the username of the user who last modified this entity.
     * 
     * @return The modifier's username, may be null
     */
    String getModifiedBy();
    
    /**
     * Sets the last modifier's username.
     * 
     * @param modifiedBy The username
     */
    void setModifiedBy(String modifiedBy);
}
