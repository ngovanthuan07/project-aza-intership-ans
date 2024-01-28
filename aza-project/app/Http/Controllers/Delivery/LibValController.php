<?php

namespace App\Http\Controllers\Delivery;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class LibValController extends Controller
{
    public function displayAll() {
        $query = DB::select('EXEC GetLibValData');

        return response()->json(
            [
                'success' => true,
                'data' => $query
            ]
        );
    }
}
