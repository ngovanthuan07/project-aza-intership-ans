<?php

namespace App\Http\Controllers\Delivery\Detail;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DetailController extends Controller
{
    public function add(Request $request) {
        $query = 'EXEC [usp_InsertDelivery]             
                         :delivery_nm1                
                    ,    :delivery_kn1                
                    ,    :delivery_nm2                
                    ,    :delivery_kn2                
                    ,    :zip_cd                      
                    ,    :prefecture_cd               
                    ,    :city_nm                     
                    ,    :town_nm                     
                    ,    :apartment_nm                
                    ,    :address1                    
                    ,    :address2                    
                    ,    :tel                         
                    ,    :fax                         
                    ,    :delivery_class_1            
                    ,    :delivery_class_2            
                    ,    :delivery_class_3            
                    ,    :remark                      
                    ,    :cre_user                    
                    ,    :cre_prg                     
                    ,    :cre_ip                      
                    ,    :cre_date                  
                    
        ';

        $result = DB::select($query, $request->all());

        if(is_array($result)) {
            $result = collect($result)->first();
        }

        return response()->json([
            'data' => $result
        ]);
    }

    public function update(Request $request) {
        $query = 'EXEC usp_UpdateDelivery
                         :delivery_cd                 
                    ,    :delivery_nm1                
                    ,    :delivery_kn1                
                    ,    :delivery_nm2                
                    ,    :delivery_kn2                
                    ,    :zip_cd                      
                    ,    :prefecture_cd               
                    ,    :city_nm                     
                    ,    :town_nm                     
                    ,    :apartment_nm                
                    ,    :address1                    
                    ,    :address2                    
                    ,    :tel                         
                    ,    :fax                         
                    ,    :delivery_class_1            
                    ,    :delivery_class_2            
                    ,    :delivery_class_3            
                    ,    :remark                                        
                    ,    :upd_user                    
                    ,    :upd_prg                     
                    ,    :upd_ip                      
                    ,    :upd_date                    
                    
        ';

        $result = DB::select($query, $request->all());
        
        if(is_array($result)) {
            $result = collect($result)->first();
        }

        return response()->json([
            'data' => $result
        ]);
    }

    public function remove(Request $request) {
        $query = 'EXEC usp_DeleteDelivery
                          :delivery_cd                 
                    ,     :del_user
                    ,     :del_prg 
                    ,     :del_ip
                    ,     :del_date
                    
        ';
        $result = DB::select($query, $request->all());
            
        if(is_array($result)) {
            $result = collect($result)->first();
        }

        return response()->json([
            'data' => $result
        ]);
    }
}
