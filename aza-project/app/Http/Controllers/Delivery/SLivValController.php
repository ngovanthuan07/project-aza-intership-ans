<?php

namespace App\Http\Controllers\Delivery;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use PDO;



class SLivValController extends Controller
{
     public function displaySearch() {
        $statement = DB::connection()->getPdo()->prepare('EXEC usp_GetLibValDeliveryClass');
        $statement->execute();

        $deliveryClassOne = $statement->fetchAll(PDO::FETCH_OBJ);
        $statement->nextRowset();
        $deliveryClassTwo = $statement->fetchAll(PDO::FETCH_OBJ);
        $statement->nextRowset();
        $deliveryClassThree = $statement->fetchAll(PDO::FETCH_OBJ);

        return response()->json(
            [
                'deliveryClassOne' =>  $deliveryClassOne,
                'deliveryClassTwo' =>  $deliveryClassTwo,
                'deliveryClassThree' => $deliveryClassThree,
            ]
        );
    }
}
