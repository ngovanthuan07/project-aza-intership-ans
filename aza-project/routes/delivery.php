<?php

use App\Http\Controllers\Delivery\Search\ExcelController;
use App\Http\Controllers\Delivery\Search\SearchController;
use App\Http\Controllers\Delivery\SLivValController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;



Route::prefix('delivery-search')->group(function () {
    Route::post('/search', [SearchController::class, 'search'])->name('delivery-search.search');
    Route::post('/excel', [ExcelController::class, 'report'])->name('delivery-search.excel');

});

Route::prefix('s_lib-val')->group(function () {
    Route::get('/display-search', [SLivValController::class, 'displaySearch'])->name('s_lib-val.display-search');
});



