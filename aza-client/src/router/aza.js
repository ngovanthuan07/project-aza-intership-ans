const aza = [
    {
        path: "/aza",
        component: () => import("../layouts/aza.vue"),
        children: [
            {
                path: "delivery-detail",
                name: "delivery-detail",
                component: () => import ("../pages/aza/delivery-detail/index.vue")
            },
            {
                path: "delivery-search",
                name: "delivery-search",
                component: () => import ("../pages/aza/delivery-search/index.vue")
            },
              // Thêm route "catch-all" cho bất kỳ route nào không khớp
            {
                path: "*",
                name: "not-found",
                component: () => import ("../pages/aza/not-found/index.vue")
            }
        ]
    }
];

export default aza;