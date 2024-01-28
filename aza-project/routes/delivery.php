<?php

use App\Http\Controllers\Delivery\LibValController;
use App\Http\Controllers\Delivery\SearchController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;



Route::prefix('delivery-search')->group(function () {
});

Route::prefix('lib-val')->group(function () {
    Route::get('/all', [LibValController::class, 'displayAll'])->name('lib_val.all');
});



