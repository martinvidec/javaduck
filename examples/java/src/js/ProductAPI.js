/**
 * JavaScript API client for product management.
 * 
 * This class provides methods to interact with the product backend service,
 * demonstrating how JavaScript and Java documentation can coexist.
 * 
 * @class ProductAPI
 * @author Frontend Team
 * @version 1.0
 * @since 3.0
 */
var ProductAPI = function(baseUrl, options) {
    options = options || {};
    
    /**
     * @property {String} baseUrl
     * The base URL of the API endpoint
     */
    this.baseUrl = baseUrl;
    
    /**
     * @property {Number} timeout
     * Request timeout in milliseconds
     * @private
     */
    this.timeout = options.timeout || 5000;
    
    /**
     * @property {String} apiKey
     * API key for authentication
     * @private
     */
    this.apiKey = options.apiKey;
};

/**
 * Fetches all products from the API.
 * 
 * @return {Promise} Promise resolving to array of products
 */
ProductAPI.prototype.getAllProducts = function() {
    var self = this;
    return this._fetch('/products').then(function(response) {
        return response.json();
    });
};

/**
 * Fetches a single product by ID.
 * 
 * @param {Number} productId The product ID
 * @return {Promise} Promise resolving to the product
 * @throws {Error} If product is not found
 */
ProductAPI.prototype.getProduct = function(productId) {
    var self = this;
    return this._fetch('/products/' + productId).then(function(response) {
        if (response.status === 404) {
            throw new Error('Product ' + productId + ' not found');
        }
        return response.json();
    });
};

/**
 * Creates a new product.
 * 
 * @param {Object} productData The product data
 * @param {String} productData.name Product name
 * @param {Number} productData.price Product price
 * @param {String} [productData.description] Product description
 * @return {Promise} Promise resolving to the created product
 */
ProductAPI.prototype.createProduct = function(productData) {
    return this._fetch('/products', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(productData)
    }).then(function(response) {
        return response.json();
    });
};

/**
 * Updates an existing product.
 * 
 * @param {Number} productId The product ID
 * @param {Object} productData The updated product data
 * @return {Promise} Promise resolving to the updated product
 */
ProductAPI.prototype.updateProduct = function(productId, productData) {
    return this._fetch('/products/' + productId, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(productData)
    }).then(function(response) {
        return response.json();
    });
};

/**
 * Deletes a product.
 * 
 * @param {Number} productId The product ID
 * @return {Promise}
 */
ProductAPI.prototype.deleteProduct = function(productId) {
    return this._fetch('/products/' + productId, {
        method: 'DELETE'
    });
};

/**
 * Searches for products matching the query.
 * 
 * @param {String} query Search query
 * @param {Object} [filters] Optional filters
 * @param {String} [filters.category] Category filter
 * @param {Number} [filters.minPrice] Minimum price
 * @param {Number} [filters.maxPrice] Maximum price
 * @return {Promise} Promise resolving to matching products
 */
ProductAPI.prototype.searchProducts = function(query, filters) {
    filters = filters || {};
    var params = Object.assign({ q: query }, filters);
    var queryString = Object.keys(params).map(function(key) {
        return key + '=' + encodeURIComponent(params[key]);
    }).join('&');
    
    return this._fetch('/products/search?' + queryString).then(function(response) {
        return response.json();
    });
};

/**
 * Internal fetch wrapper with authentication and error handling.
 * 
 * @param {String} endpoint The API endpoint
 * @param {Object} [options] Fetch options
 * @return {Promise} The fetch promise
 * @private
 */
ProductAPI.prototype._fetch = function(endpoint, options) {
    options = options || {};
    var url = this.baseUrl + endpoint;
    var headers = Object.assign({}, options.headers);
    
    if (this.apiKey) {
        headers['Authorization'] = 'Bearer ' + this.apiKey;
    }
    
    var fetchOptions = Object.assign({}, options, {
        headers: headers,
        timeout: this.timeout
    });
    
    return fetch(url, fetchOptions).then(function(response) {
        if (!response.ok && response.status !== 404) {
            throw new Error('API error: ' + response.status + ' ' + response.statusText);
        }
        return response;
    });
};

/**
 * Static factory method to create a ProductAPI with default settings.
 * 
 * @param {String} apiKey The API key
 * @return {ProductAPI} A configured ProductAPI instance
 * @static
 */
ProductAPI.createDefault = function(apiKey) {
    return new ProductAPI('https://api.example.com', {
        apiKey: apiKey,
        timeout: 10000
    });
};
