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
                <button 
                    @click="onCurrentPage(page)" 
                    class="page-link"
                    :class="{ 'active' : isActive(page)}"
                    href="#">
                    {{ page > 0 ? page : '...' }}
                </button>
            </li>
            <li class="page-item">
                <button @click="onNextPage(page)"  class="page-link" href="#" aria-label="Next">
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
import { ref, computed, defineProps } from 'vue';
import { handListPage } from '../helpers/pagination.js';

export default {
    props: {
        
    },
    methods: {
        async onStartPage () {
            try {
                let minP = await this.$store.getters['pagination/minPageItem'];
                await this.$store.dispatch('pagination/onChangeCurrentPage', minP);
                console.log('Change current page successful');
            } catch (error) {
                console.error('Error changing current page:', error);
            }
        },
        async onPrevPage () {
            try {
                let prev = await this.$store.getters['pagination/currentPage'] - 1;
                let minP = await this.$store.getters['pagination/minPageItem'];
                if(prev + 1 === minP){
                    return
                }
            
                await this.$store.dispatch('pagination/onChangeCurrentPage', prev);
                console.log('Change current page successful');
            } catch (error) {
                console.error('Error changing current page:', error);
            }
        },
        async onCurrentPage (cPage) {
            try {
                if(cPage === -1) 
                    return;
                await this.$store.dispatch('pagination/onChangeCurrentPage', cPage);
                console.log('Change current page successful');
            } catch (error) {
                console.error('Error changing current page:', error);
            }
        },
        async onNextPage () {
            try {
                let next = await this.$store.getters['pagination/currentPage'] + 1;
                let maxP = await this.$store.getters['pagination/maxPageItem'];
                if(next - 1 === maxP){
                    return
                }
                console.log(next);
                await this.$store.dispatch('pagination/onChangeCurrentPage', next);
                console.log('Change current page successful');
            } catch (error) {
                console.error('Error changing current page:', error);
            }
        },
        async onEndPage () {
            try {
                let maxP = await this.$store.getters['pagination/maxPageItem'];
                await this.$store.dispatch('pagination/onChangeCurrentPage', maxP);
                console.log('Change current page successful');
            } catch (error) {
                console.error('Error changing current page:', error);
            }
        },
        isActive(page) {
            let curP =  this.$store.getters['pagination/currentPage'] * 1;
            return curP === page ? true : false;
        }
    },
    computed: {
        filteredPagination () {
            return handListPage(
                this.$store.getters['pagination/minPageItem'], this.$store.getters['pagination/maxPageItem'], this.$store.getters['pagination/currentPage']);
        }
    },
    setup(props) {

        return {
            
        };
    },
};
</script>

<style>
.pagination .page-link {
   width: 10px;
   height: 10px;
   display: flex;
   justify-content: center;
   align-items: center;
   font-size: 10px;
}
</style>