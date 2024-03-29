<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;

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
        return [
            '納入先コード', '納入先名', 'フリガナ', '郵便番号', '住所', '電話番号', 'FAX番号', '納入先分類１', '納入先分類２', '納入先分類３', '備考', '登録日付', '登録利用者', '最終更新', '最終利用者名'
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

        $sheet->getStyle('A2:' . $highestColumn . $highestRow)->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT);

        $sheet->getStyle('D2:D' . $highestRow)->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT);

        $sheet->getStyle('F2:G' . $highestRow)->getNumberFormat()->setFormatCode(NumberFormat::FORMAT_TEXT);

        return [
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
            2    => [
                'borders' => $styleArray['borders'],
            ],
            'A2:' . $highestColumn . $highestRow => [
                'borders' => $styleArray['borders'],
            ],
        ];
    }
}
