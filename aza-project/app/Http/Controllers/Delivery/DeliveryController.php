<?php

namespace App\Http\Controllers\Delivery;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DeliveryController extends Controller
{
    public function getByDeliveryCd(Request $request) {
        $query = 'EXEC usp_FindByDeliveryCDOnM_Delivery
                        :delivery_cd';
        $result = DB::select($query, $request->all());
    
        $delivery = collect($result)->first();
        
        return response()->json([
            'delivery' => $delivery
        ]);
    }
}
