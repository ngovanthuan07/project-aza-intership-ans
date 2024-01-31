<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
class DeliveryExport implements FromCollection, WithHeadings, ShouldAutoSize, WithStyles
{
    protected $data;

    public function __construct($data)
    {
        $this->data = $data;
    }

    public function collection()
    {
        return collect($this->data);
    }

    public function headings(): array
    {
        // Thêm tiêu đề cột ở đây
        return [
            'Delivery Code', 'Delivery Name 1', 'Delivery Name 2',
            'Knowledge 1', 'Knowledge 2', 'Address', 'Telephone',
            'Lib Val Name 1', 'Lib Val Code 1', 'Lib Val Name 2', 'Lib Val Code 2',
            'Lib Val Name 3', 'Lib Val Code 3'
        ];
    }

    public function styles(Worksheet $sheet)
    {
        $highestRow = $sheet->getHighestDataRow(); // Lấy hàng dữ liệu cuối cùng
        $highestColumn = $sheet->getHighestDataColumn(); // Lấy cột dữ liệu cuối cùng

        $styleArray = [
            'borders' => [
                'allBorders' => [
                    'borderStyle' => Border::BORDER_THIN,
                    'color' => ['argb' => 'FF000000'],
                ],
            ],
        ];

        return [
            // Căn giữa tiêu đề
            1    => [
                'alignment' => [
                    'horizontal' => Alignment::HORIZONTAL_CENTER,
                    'vertical' => Alignment::VERTICAL_CENTER,
                ],
                'fill' => [
                    'fillType' => \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
                    'color' => ['argb' => 'FFFF99'],
                ],
                'borders' => $styleArray['borders'],
            ],
            // Áp dụng viền cho các hàng dữ liệu
            2    => [
                'borders' => $styleArray['borders'],
            ],
            // Áp dụng viền cho phạm vi chứa dữ liệu
            'A2:' . $highestColumn . $highestRow => [
                'borders' => $styleArray['borders'],
            ],
        ];
    }
}
