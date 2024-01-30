<template>
    <nav aria-label="Page navigation pagination-nav">
        <ul class="pagination">
            <li class="page-item">
                <button @click="onStartPage(page)" class="page-link" href="#" aria-label="Previous">
                    <span aria-hidden="true">&lt;&lt;</span>
                </button>
            </li>
            <li class="page-item">
                <button @click="onPrevPage(page)" class="page-link" href="#" aria-label="Previous">
                    <span aria-hidden="true">&lt;</span>
                </button>
            </li>
            <li class="page-item" v-for="(page) in filteredPagination">
                <button @click="onCurrentPage(page)" class="page-link" :class="{ 'active': isActive(page) }" href="#">
                   <span> {{ page > 0 ? page : '...' }}</span>
                </button>
            </li>
            <li class="page-item">
                <button @click="onNextPage(page)" class="page-link" href="#" aria-label="Next">
                    <span aria-hidden="true">&gt;</span>
                </button>
            </li>
            <li class="page-item">
                <button @click="onEndPage()" class="page-link" href="#" aria-label="Next">
                    <span aria-hidden="true">&gt;&gt;</span>
                </button>
            </li>
        </ul>
    </nav>
</template>

<script>
import { handListPage } from '../../../helpers/pagination.js';
import {AC_CHANGE_DATATABLES} from "../../../store/modules/data-table/types.js";
import { createNamespacedHelpers } from 'vuex';
const { mapState: mapDatableState, mapActions: mapDatatableActions } = createNamespacedHelpers('dataTable');


export default {
    props: {

    },
    methods: {
        ...mapDatatableActions([
            AC_CHANGE_DATATABLES
        ]),
        async onStartPage() {
            try {
                let minP = await this.startPage;
                await this[CHANGE_CURRENT_PAGE](minP);
                console.log('Change current page successful');
            } catch (error) {
                console.error('Error changing current page:', error);
            }
        },
        async onPrevPage() {
            try {
                let prev = await this.currentPage - 1;
                let minP = await this.startPage;
                if (prev + 1 === minP) {
                    return
                }

                await this[CHANGE_CURRENT_PAGE](prev);
                console.log('Change current page successful');
            } catch (error) {
                console.error('Error changing current page:', error);
            }
        },
        async onCurrentPage(cPage) {
            try {
                if (cPage === -1)
                    return;
                await this[CHANGE_CURRENT_PAGE](cPage);
                console.log('Change current page successful');
            } catch (error) {
                console.error('Error changing current page:', error);
            }
        },
        async onNextPage() {
            try {
                let next = await this.currentPage + 1;
                let maxP = await this.totalPages;
                if (next - 1 === maxP) {
                    return
                }
                await this[CHANGE_CURRENT_PAGE](next);
                console.log('Change current page successful');
            } catch (error) {
                console.error('Error changing current page:', error);
            }
        },
        async onEndPage() {
            try {
                let maxP = await this.totalPages;
                await this[CHANGE_CURRENT_PAGE](maxP);
                console.log('Change current page successful');
            } catch (error) {
                console.error('Error changing current page:', error);
            }
        },
        isActive(page) {
            let curP = this.currentPage * 1;
            return curP === page ? true : false;
        }
    },
    computed: {
        ...mapDatableState({
            currentPage: state => state.currentPage,
            totalPages: state => state.totalPages,
            startPage: state => state.startPage
        }),
        filteredPagination() {
            return handListPage(this.startPage, this.totalPages, this.currentPage);
        }
    },
    setup(props) {

        return {

        };
    },
    data() {
        return {

        }
    }
};
</script>

<style scoped>
@import './css/css.css';
</style>