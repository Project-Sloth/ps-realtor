<script lang="ts">
    export let width: string | number = "60%";
    export let height: string | number = "90%";
</script>

<article class="modal" style:width={width} style:height={height}>
    <slot/>
</article>

<div class="modal-overlay"></div>

<style>
    .modal {
        position: absolute;

        z-index: 1;

        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
    }

    .modal-overlay {
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.6);
    }
</style>