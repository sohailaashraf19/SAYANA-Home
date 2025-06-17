<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\OfferController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\ProductImageController;
use App\Http\Controllers\WishlistController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\BuyerProfileController;
use App\Http\Controllers\Auth\sellerController;
use App\Http\Controllers\SellerProfileController;
use App\Http\Controllers\Auth\BuyerPasswordResetController;
use App\Http\Controllers\Auth\SellerPasswordResetController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\Auth\BuyerController;
use App\Http\Controllers\Auth\ForgotPasswordbuyerController;
use App\Http\Controllers\Auth\forgetpasswordsellercontroller;


Route::get('/search/all', [OrderController::class, 'searchBuyerAndSeller']);
Route::PUT('/orderupdate-status', [OrderController::class, 'updateOrderItemStatusBySeller']);
Route::get('/products/best-selling', [ProductController::class, 'bestSellingProducts']);
Route::get('/get_all_products', [ProductController::class, 'get_all_products']);
Route::post('/add_product', [ProductController::class, 'addProduct']);
Route::get('/get_products_byid/{product_id}', [ProductController::class, 'getProductById']);
Route::put('/update_product/{product_id}', [ProductController::class, 'update_product']);
Route::get('/get_product_by_id/{product_id}', [ProductController::class, 'getProductById']);
Route::get('/get_product_by_seller_id', [ProductController::class, 'getProductsBySeller']);
Route::delete('/delete_products/{product_id}', [ProductController::class, 'deleteProduct']);
Route::get('/products_category/{category_id}', [ProductController::class, 'getProductsByCategory']);
Route::get('/products_seller/{brand_name}', [ProductController::class, 'getProductsByBrand']);
Route::get('/showalloffer', [OfferController::class, 'showalloffer']);
Route::post('/addnewoffer', [OfferController::class, 'addoffer']);
Route::get('/showoffer/{id}', [OfferController::class, 'showoffer']);
Route::put('/updateoffer/{id}', [OfferController::class, 'updateoffer']);
Route::delete('/deletoffer/{id}', [OfferController::class, 'deletoffer']);
Route::get('/history_order/{buyer_id}', [OrderController::class, 'getOrderHistory']);
Route::post('/neworders', [OrderController::class, 'createOrder']);
Route::put('/updateorder/{order_id}', [OrderController::class, 'updateOrder']);
Route::delete('/deletorder/{order_id}', [OrderController::class, 'cancelOrder']);
Route::post('/cart_add', [CartController::class, 'addToCart']);
Route::get('/getcart', [CartController::class, 'getCart']);
Route::delete('/cartdelet/{id}', [CartController::class, 'removeFromCart']);
Route::delete('/cartclear', [CartController::class, 'clearCart']);
Route::get('/sellerstop-customers/{sellerId}', [OrderController::class, 'getTopCustomers']);
Route::get('/getTopSellingProducts', [OrderController::class, 'getTopSellingProductsForSeller']);
Route::put('/cart_update/{id}', [CartController::class, 'updateCartItem']);
Route::post('/upload-images', [ProductController::class, 'store']);
Route::post('/addproduct', [ProductController::class, 'addProduct']);
Route::get('/discounted-products', [ProductController::class, 'getDiscountedProducts']);
// Public routes (no auth)
Route::get('/getwishlist', [WishlistController::class, 'getWishlist']);
Route::post('/addwishlist', [WishlistController::class, 'addToWishlist']);

Route::delete('/removewishlist/{id}', [WishlistController::class, 'removeFromWishlist']);

Route::delete('/clearwishlist_clear', [WishlistController::class, 'clearWishlist']);
Route::get('/getcomments', [CommentController::class, 'index']);          // List all comments
Route::post('/creatcomments', [CommentController::class, 'store']);         // Create comment
Route::get('/getsinglecommentcomments/{comment_id}', [CommentController::class, 'show']); // Get single comment
Route::put('/updatecomments/{comment_id}', [CommentController::class, 'update']); // Update comment
Route::delete('/deletcomments/{comment}', [CommentController::class, 'destroy']);
Route::get('/commet_product/{id}', [CommentController::class, 'getCommentsForProduct']);
Route::get('/getAllCategories', [CategoryController::class, 'getAllCategories']);
Route::post('/storeCategory', [CategoryController::class, 'storeCategory']);
Route::put('/updateCategory/{id}', [CategoryController::class, 'updateCategory']);
Route::delete('/deleteCategory/{id}', [CategoryController::class, 'deleteCategory']);
Route::get('/getOrderDetails/{orderId}', [OrderController::class, 'getOrderDetails']);
Route::prefix('buyer')->group(function () {
    Route::post('/register', [BuyerController::class, 'register']);
    Route::post('/login', [BuyerController::class, 'login']);
    Route::post('/logout', [BuyerController::class, 'logout'])->middleware('auth:sanctum');
    Route::get('/profile', [BuyerProfileController::class, 'show'])->middleware('auth:sanctum');
    Route::put('/profile', [BuyerProfileController::class, 'update'])->middleware('auth:sanctum');
    Route::post('/forgot-password/request-otp', [ForgotPasswordbuyerController::class, 'requestOtp']);
    Route::post('/forgot-password/verify-otp', [ForgotPasswordbuyerController::class, 'verifyOtp']);
    Route::post('/forgot-password/reset', [ForgotPasswordbuyerController::class, 'resetPassword']);

    
});
Route::prefix('seller')->group(function () {
    Route::post('/register', [sellerController::class, 'register']);
    Route::post('/login', [sellerController::class, 'login']);
    Route::post('/logout', [sellerController::class, 'logout'])->middleware('auth:sanctum');
    Route::get('/profile', [SellerProfileController::class, 'show'])->middleware('auth:sanctum');
    Route::put('/profile', [SellerProfileController::class, 'update'])->middleware('auth:sanctum');
    Route::post('/forgot-password/request-otp', [forgetpasswordsellercontroller::class, 'requestOtp']);
    Route::post('/forgot-password/verify-otp', [forgetpasswordsellercontroller::class, 'verifyOtp']);
    Route::post('/forgot-password/reset', [forgetpasswordsellercontroller::class, 'resetPassword']);

});
Route::prefix('admin')->group(function () {
    Route::post('/login', [AdminController::class, 'login']);
    Route::post('/logout', [AdminController::class, 'logout'])->middleware('auth:sanctum');
});
Route::get('/sellerunique-buyers/{id}', [OrderController::class, 'getUniqueBuyersCount']);
Route::get('/sellerorders-count/{id}/', [OrderController::class, 'getSellerOrdersCount']);
Route::get('/sellerrevenue/{id}', [OrderController::class, 'getSellerNetProfit']);
Route::get('/revenueforadmin', [ProductController::class, 'getPlatformProfit']);
Route::get('/sellerscount', [ProductController::class, 'countAllSellers']);
Route::get('/buyerscount', [ProductController::class, 'countAllBuyers']);
Route::get('/calculateSellerPaidOrders/{sellerId}', [OrderController::class, 'calculateSellerPaidOrders']);
Route::get('/calculateTotalPaidOrders', [OrderController::class, 'calculateTotalPaidOrders']);
Route::get('/admincount-products', [ProductController::class, 'countAllProducts']);
Route::get('/sellercount-products', [ProductController::class, 'countProductsBySeller']);
 Route::get('/getAllorder', [OrderController::class, 'getAllOrders']);
Route::post('/report-product', [ProductController::class, 'reportProduct']);
Route::get('/adminproducts', [ProductController::class, 'get_all_products_for_admin']);
Route::get('/getOrdersForSeller', [OrderController::class, 'getOrdersForSeller']);
Route::get('/search', [ProductController::class, 'search']);
Route::get('/allseller', [SellerProfileController::class, 'getAllSellers']);
Route::get('/productsreported', [ProductController::class, 'getProductsWithTwoOrMoreReports']);
Route::get('/buyerstop', [OrderController::class, 'getTopCustomersadmin']);
 Route::get('/getAllBuyers', [OrderController::class, 'getAllBuyers']);