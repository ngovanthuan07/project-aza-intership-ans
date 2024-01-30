<template>
    <div class="sidebar-container">
        <ul class="sidebar navbar-nav mr-auto">
            <!-- A -->
            <li class="sidebar-item nav-item">
                <button class="nav-link" href="#">
                    <font-awesome-icon :icon="['fas', 'envelope']" />
                    <span class="sidebar-content">お知らせ</span>
                </button>
            </li>
            <!-- B -->
            <li class="sidebar-item nav-item">
                <button class="nav-link" href="#">
                    <font-awesome-icon :icon="['fas', 'calendar-days']" />
                    <span class="sidebar-content">シフト</span>
                </button>
            </li>
            <!-- C -->
            <li class="sidebar-item nav-item">
                <button class="nav-link" href="#">
                    <font-awesome-icon :icon="['fas', 'barcode']" />
                    <span class="sidebar-content">在庫</span>
                </button>
            </li>
            <!-- D -->
            <li class="sidebar-item nav-item">
                <button class="nav-link" href="#">
                    <font-awesome-icon :icon="['fas', 'clipboard']" />
                    <span class="sidebar-content">ハンディ</span>
                </button>
            </li>
            <!-- E -->
            <li class="sidebar-item nav-item">
                <button class="nav-link" href="#">
                    <font-awesome-icon :icon="['fas', 'chart-line']" />
                    <span class="sidebar-content">売上</span>
                </button>
            </li>
            <!-- F -->
            <li class="sidebar-item nav-item">
                <button class="nav-link" href="#">
                    <font-awesome-icon :icon="['fas', 'box-open']" />
                    <span class="sidebar-content">仕入</span>
                </button>
            </li>
            <!-- G -->
            <li class="sidebar-item nav-item" :class="{ 'active': $route.name === 'delivery-search-from' }">

                <router-link :to="{ name: 'delivery-search-from' }" class="nav-link sidebar-router" href="#">
                    <font-awesome-icon :icon="['fas', 'up-long']" />
                    <span class="sidebar-content">データ出力</span>
                </router-link>
            </li>
            <!-- H -->
            <li class="sidebar-item nav-item" :class="{ 'active': $route.name === 'delivery-detail' }">

                <router-link :to="{ name: 'delivery-detail' }" class="nav-link sidebar-router" href="#">
                    <font-awesome-icon :icon="['fas', 'star']" />
                    <span class="sidebar-content">マスター</span>
                </router-link>

            </li>
            <!-- I -->
            <li class="sidebar-item nav-item">
                <button class="nav-link" href="#">
                    <font-awesome-icon :icon="['fas', 'gear']" />
                    <span class="sidebar-content">設定</span>
                </button>
            </li>
        </ul>
    </div>
</template>

<script>
export default {
    data() {
        return {
            activeTab: null,
        };
    },
    methods: {
        setActiveTab(tab) {
            this.activeTab = tab;
        },
    },
};
</script>