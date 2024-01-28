<template>
    <div class="top col-12 header">
        <div class="right">
            <img src="https://mdbootstrap.com/img/Photos/Avatars/img (31).webp" class="rounded-circle right" height="30"
                alt="" loading="lazy" />
            <div class="p-2 text-white fs-6 text-center">
                0123456:こんいちわ
            </div>
            <div class="dropdown">
                <font-awesome-icon :icon="['fas', 'fa-caret-down']" class="text-white" />
                <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                    <li><a class="dropdown-item" href="#">Action</a></li>
                    <li><a class="dropdown-item" href="#">Another action</a></li>
                    <li><a class="dropdown-item" href="#">Something else here</a></li>
                </ul>
            </div>
        </div>
    </div>
</template>