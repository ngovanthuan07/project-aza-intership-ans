<?php

namespace App\Http\Controllers\Delivery\Search;

use App\Exports\DeliveryExport;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;

class ExcelController extends Controller
{
    public function report(Request $request)
    {
        $query = 'EXEC usp_DeliveryExcel
                     :delivery_cd
                ,    :delivery_nm
                ,    :delivery_kn
                ,    :address
                ,    :tel
                ,    :delivery_class_1
                ,    :delivery_class_2
                ,    :delivery_class_3';
        $data = DB::select($query, $request->all());

        $export = new DeliveryExport($data);;

        $fileName = 'excel_' . now()->format('Y_m_d_His') . '.xlsx';
        $filePath = 'excel/' . $fileName;

        Excel::store($export, $filePath, 'public');

        return response()->json([
            'file_path' => asset('storage/' . $filePath)
        ]);
    }
}
