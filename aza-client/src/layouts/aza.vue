<template>
    <div class="grow">
        <TheHeader />
        <div class="box-container col-12 d-flex">
            <Sidebar />
            <router-view></router-view>
        </div>
    </div>
    <div class="action-buttons-container">
        <div class="col-12 py-3">
            Footer
        </div>
    </div>
</template>

<script>
import TheHeader from '../components/TheHeader.vue'
import Sidebar from '../components/Sidebar.vue'

export default {
    components: {
        TheHeader,
        Sidebar
    }
}

</script>