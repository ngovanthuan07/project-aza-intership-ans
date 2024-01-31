<?php

namespace App\Http\Controllers\Delivery\Search;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use PDO;

class ExcelController extends Controller
{
    public function report(Request $request)
    {
        $query = 'EXEC usp_DeliverySearch 
                         :delivery_cd
                    ,    :delivery_nm
                    ,    :delivery_kn
                    ,    :address
                    ,    :tel
                    ,    :delivery_class_1
                    ,    :delivery_class_2
                    ,    :delivery_class_3';

        $statement = DB::connection()->getPdo()->prepare($query);

        $statement->execute($request->all());

        $results = $statement->fetchAll(PDO::FETCH_OBJ);

        // Move to the next result set
        $statement->nextRowset();

        $totalPages = $statement->fetchAll(PDO::FETCH_OBJ);

        return response()->json([
            'data' => $results,
        ]);
    }
}
