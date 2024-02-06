// app/Models/Delivery.php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Delivery extends Model
{
    protected $table = 'm_delivery';
    protected $primaryKey = 'delivery_cd';
    public $timestamps = false; // Assuming you manage timestamps in the stored procedure

    // Other model properties...

    public static function insertDelivery($data)
    {
        // Assuming $data is an associative array with input values

        try {
            \DB::beginTransaction();

            // Insert data into the m_delivery table
            self::create($data);

            \DB::commit();
        } catch (\Exception $e) {
            \DB::rollBack();
            // Handle the exception as per your requirements
            // You can log the error, throw an exception, etc.
            // For example:
            throw new \Exception("Error inserting delivery: " . $e->getMessage());
        }
    }
}
