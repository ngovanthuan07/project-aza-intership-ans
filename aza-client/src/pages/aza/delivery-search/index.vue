<template>
    <div class="content-container ">
        <div class="content-header">
            <div class="content-header-left">
                <div class="content-header-item content-header-item-left">
                    納入先一覧
                </div>
            </div>
        </div>
        <div class="content">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-2">
                        <!-- h3 -->
                        <div class="form-group">
                            <label>納入先コード</label>
                            <input type="text" class="form-control">
                        </div>
                    </div>
                    <!-- h4 -->
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>納入先名</label>
                            <input type="text" class="form-control">
                        </div>
                    </div>

                    <!-- h5 -->
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>フリガナ</label>
                            <input type="text" class="form-control">
                        </div>
                    </div>
                    <!-- h6 -->
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>住所</label>
                            <input type="text" class="form-control">
                        </div>
                    </div>
                    <!-- h7 -->
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>電話番号</label>
                            <input type="text" class="form-control">
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- h8 -->
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>納入先分類１</label>
                            <select class="form-select">
                                <option value="1">One</option>
                                <option value="2">Two</option>
                                <option value="3">Three</option>
                            </select>
                        </div>
                    </div>
                     <!-- h9 -->
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>納入先分類２</label>
                            <select class="form-select">
                                <option value="1">One</option>
                                <option value="2">Two</option>
                                <option value="3">Three</option>
                            </select>
                        </div>
                    </div>
                     <!-- h10 -->
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>納入先分類３</label>
                            <select class="form-select">
                                <option value="1">One</option>
                                <option value="2">Two</option>
                                <option value="3">Three</option>
                            </select>
                        </div>
                    </div>
                </div>

                <hr>

                <TableDetail />

            </div>
        </div>
    </div>
</template>
<style scoped>
@import '../../../assets/css/delivery-search.css';
</style>
<script>
import TableDetail from '../../../components/TableDetail.vue';
export default {
    components: {
        TableDetail
    }
}

</script>