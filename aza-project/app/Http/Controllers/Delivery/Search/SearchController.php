<?php

namespace App\Http\Controllers\Delivery\Search;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use PDO;

class SearchController extends Controller
{
    public function search(Request $request)
    {
        $query = 'EXEC usp_DeliverySearch 
                         :delivery_cd
                    ,    :delivery_nm
                    ,    :delivery_kn
                    ,    :address
                    ,    :tel
                    ,    :delivery_class_1
                    ,    :delivery_class_2
                    ,    :delivery_class_3
                    ,    :sortColumn
                    ,    :sortType
                    ,    :currentPage
                    ,    :limit';

        $statement = DB::connection()->getPdo()->prepare($query);

        $statement->execute($request->all());

        $results = $statement->fetchAll(PDO::FETCH_OBJ);

        $statement->nextRowset();
        $pageSize = $request->input('limit' , 10);
        $totalItems = (int) $statement->fetchAll(PDO::FETCH_OBJ)[0]->totalItems;
        $totalPages =  ceil($totalItems / $pageSize);

        return response()->json([
            'resultSearch' => $results,
            'totalItems' => $totalItems,
            'totalPages' => $totalPages
        ]);
    }
}
