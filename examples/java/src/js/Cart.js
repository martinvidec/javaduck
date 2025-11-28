/**
 * Shopping cart implementation for the e-commerce frontend.
 * 
 * Manages cart items, calculates totals, and handles discount codes.
 * This demonstrates mixed Java/JavaScript documentation in JavaDuck.
 * 
 * @class Cart
 * @author Frontend Team
 * @version 2.0
 * @since 1.0
 */
var Cart = function() {
    /**
     * @property {Array} items
     * Array of cart items
     * @private
     */
    this.items = [];
    
    /**
     * @property {String} discountCode
     * Applied discount code
     * @private
     */
    this.discountCode = null;
    
    /**
     * @property {Number} discountPercent
     * Discount percentage (0-100)
     * @private
     */
    this.discountPercent = 0;
};

/**
 * Adds a product to the cart.
 * 
 * @param {Object} product The product to add
 * @param {Number} product.id Product ID
 * @param {String} product.name Product name
 * @param {Number} product.price Product price
 * @param {Number} [quantity=1] Quantity to add
 * @fires Cart#itemAdded
 */
Cart.prototype.addItem = function(product, quantity) {
    quantity = quantity || 1;
    var existingItem = null;
    
    for (var i = 0; i < this.items.length; i++) {
        if (this.items[i].product.id === product.id) {
            existingItem = this.items[i];
            break;
        }
    }
    
    if (existingItem) {
        existingItem.quantity += quantity;
    } else {
        this.items.push({
            product: product,
            quantity: quantity
        });
    }
    
    this.emit('itemAdded', { product: product, quantity: quantity });
};

/**
 * Removes a product from the cart.
 * 
 * @param {Number} productId The product ID to remove
 * @return {Boolean} true if item was removed
 * @fires Cart#itemRemoved
 */
Cart.prototype.removeItem = function(productId) {
    for (var i = 0; i < this.items.length; i++) {
        if (this.items[i].product.id === productId) {
            var removedItem = this.items.splice(i, 1)[0];
            this.emit('itemRemoved', { product: removedItem.product });
            return true;
        }
    }
    return false;
};

/**
 * Updates the quantity of a cart item.
 * 
 * @param {Number} productId The product ID
 * @param {Number} quantity The new quantity
 * @throws {Error} If quantity is negative
 */
Cart.prototype.updateQuantity = function(productId, quantity) {
    if (quantity < 0) {
        throw new Error('Quantity cannot be negative');
    }
    
    if (quantity === 0) {
        this.removeItem(productId);
        return;
    }
    
    for (var i = 0; i < this.items.length; i++) {
        if (this.items[i].product.id === productId) {
            this.items[i].quantity = quantity;
            return;
        }
    }
};

/**
 * Applies a discount code to the cart.
 * 
 * @param {String} code The discount code
 * @return {Boolean} Success status
 */
Cart.prototype.applyDiscountCode = function(code) {
    var validCodes = {
        'SAVE10': 10,
        'SAVE20': 20,
        'SAVE50': 50
    };
    
    if (validCodes[code]) {
        this.discountCode = code;
        this.discountPercent = validCodes[code];
        return true;
    }
    
    return false;
};

/**
 * Calculates the subtotal (before discounts).
 * 
 * @return {Number} The subtotal amount
 */
Cart.prototype.calculateSubtotal = function() {
    var total = 0;
    for (var i = 0; i < this.items.length; i++) {
        total += this.items[i].product.price * this.items[i].quantity;
    }
    return total;
};

/**
 * Calculates the discount amount.
 * 
 * @return {Number} The discount amount
 */
Cart.prototype.calculateDiscount = function() {
    var subtotal = this.calculateSubtotal();
    return subtotal * (this.discountPercent / 100);
};

/**
 * Calculates the total (after discounts).
 * 
 * @return {Number} The total amount
 */
Cart.prototype.calculateTotal = function() {
    return this.calculateSubtotal() - this.calculateDiscount();
};

/**
 * Gets the number of items in the cart.
 * 
 * @return {Number} Total item count
 */
Cart.prototype.getItemCount = function() {
    var count = 0;
    for (var i = 0; i < this.items.length; i++) {
        count += this.items[i].quantity;
    }
    return count;
};

/**
 * Checks if the cart is empty.
 * 
 * @return {Boolean} true if cart has no items
 */
Cart.prototype.isEmpty = function() {
    return this.items.length === 0;
};

/**
 * Clears all items from the cart.
 * 
 * @fires Cart#cleared
 */
Cart.prototype.clear = function() {
    this.items = [];
    this.discountCode = null;
    this.discountPercent = 0;
    this.emit('cleared');
};

/**
 * Dummy event emitter (simplified).
 * 
 * @param {String} event Event name
 * @param {Object} data Event data
 * @private
 */
Cart.prototype.emit = function(event, data) {
    // In real implementation, this would use proper event system
    console.log('Event: ' + event, data);
};

/**
 * @event Cart#itemAdded
 * Fired when an item is added to the cart
 * @type {Object}
 * @property {Object} product The added product
 * @property {Number} quantity The quantity added
 */

/**
 * @event Cart#itemRemoved
 * Fired when an item is removed from the cart
 * @type {Object}
 * @property {Object} product The removed product
 */

/**
 * @event Cart#cleared
 * Fired when the cart is cleared
 */
