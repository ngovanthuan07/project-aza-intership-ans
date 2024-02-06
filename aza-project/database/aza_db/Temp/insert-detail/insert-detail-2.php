// ExampleController.php

namespace App\Http\Controllers;

use App\Models\Delivery;
use Illuminate\Http\Request;

class ExampleController extends Controller
{
    public function insertDelivery(Request $request)
    {
        $data = $request->all(); // Assuming you are passing data via a POST request

        try {
            Delivery::insertDelivery($data);
            return response()->json(['success' => true, 'message' => 'Delivery inserted successfully']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }
}