<?php

use App\Http\Controllers\Delivery\DeliveryController;
use App\Http\Controllers\Delivery\Detail\DetailController;
use App\Http\Controllers\Delivery\Search\ExcelController;
use App\Http\Controllers\Delivery\Search\SearchController;
use App\Http\Controllers\Delivery\SLivValController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;



Route::prefix('delivery-search')->group(function () {
    Route::post('/search', [SearchController::class, 'search'])->name('delivery-search.search');
    Route::post('/excel', [ExcelController::class, 'report'])->name('delivery-search.excel');

});


Route::prefix('delivery-detail')->group(function () {
    Route::post('/update', [DetailController::class, 'update'])->name('delivery-detail.update');
    Route::post('/add', [DetailController::class, 'add'])->name('delivery-detail.add');
    Route::post('/remove', [DetailController::class, 'remove'])->name('delivery-detail.remove');
});

Route::prefix('s_lib-val')->group(function () {
    Route::get('/display-search', [SLivValController::class, 'displaySearch'])->name('s_lib-val.display-search');
});


Route::prefix('delivery')->group(function () {
    Route::post('/get-by-delivery_cd', [DeliveryController::class, 'getByDeliveryCd'])->name('delivery.getByDeliveryCd');
});



