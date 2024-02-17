import Swal from "sweetalert2";


export async function questionAlert(title, text) {
    const c = await Swal.fire({
        title: `${title}`,
        text: `${text}`,
        icon: "question",
        showCancelButton: true,
        confirmButtonText: "はい",
        cancelButtonText: "いいえ",
        reverseButtons: false,
        customClass: {
            heightAuto: false,
            title: 'swal-custom-title',
            htmlContainer: 'swal-custom-content',
            popup: 'swal-custom-popup',
            icon: 'C007-icon',
            confirmButton: "btn-confirm-modal",
            cancelButton: "btn-cancel-modal"
        }
    })
    return c.isConfirmed;
}
export async function errorAlert(title, text) {
    await Swal.fire({
        title: `${title}`,
        text: `${text}`,
        icon: "error",
        showConfirmButton: false,
        showCancelButton: true,
        cancelButtonText: "はい\n",
        customClass: {
            heightAuto: false,
            title: 'swal-custom-title',
            htmlContainer: 'swal-custom-content',
            popup: 'swal-custom-popup',
            icon: 'swal-E007-icon',
            cancelButton: "btn-cancel-modal"
        }
    })
}
export async function infoAlert(title, text) {
    await Swal.fire({
        title: `${title}`,
        text: `${text}`,
        icon: "info",
        showConfirmButton: false,
        showCancelButton: true,
        cancelButtonText: "はい\n",
        customClass: {
            heightAuto: false,
            title: 'swal-custom-title',
            htmlContainer: 'swal-custom-content',
            popup: 'swal-custom-popup',
            icon: 'swal-I008-icon',
            cancelButton: "btn-cancel-modal"
        }
    })
}


export async function C007() {
    const C007 = await Swal.fire({
        title: "[C007]",
        text: "ファイルを出力してもよろしいですか。\n",
        icon: "question",
        showCancelButton: true,
        confirmButtonText: "はい",
        cancelButtonText: "いいえ",
        reverseButtons: false,
        customClass: {
            heightAuto: false,
            title: 'swal-custom-title',
            htmlContainer: 'swal-custom-content',
            popup: 'swal-custom-popup',
            icon: 'C007-icon',
            confirmButton: "btn-confirm-modal",
            cancelButton: "btn-cancel-modal"
        }
    })
    return C007.isConfirmed;
}

export async function E007() {
    await Swal.fire({
        title: "[E007]",
        text: "該当データは存在しません。",
        icon: "error",
        showConfirmButton: false,
        showCancelButton: true,
        cancelButtonText: "はい\n",
        customClass: {
            heightAuto: false,
            title: 'swal-custom-title',
            htmlContainer: 'swal-custom-content',
            popup: 'swal-custom-popup',
            icon: 'swal-E007-icon',
            cancelButton: "btn-cancel-modal"
        }
    })
}

export async function I008() {
    await Swal.fire({
        title: "[I008]",
        text: "出力が完了しました。\n",
        icon: "info",
        showConfirmButton: false,
        showCancelButton: true,
        cancelButtonText: "はい\n",
        customClass: {
            heightAuto: false,
            title: 'swal-custom-title',
            htmlContainer: 'swal-custom-content',
            popup: 'swal-custom-popup',
            icon: 'swal-I008-icon',
            cancelButton: "btn-cancel-modal"
        }
    })
}