<script lang="ts">
    export let width: string | number = "60%";
    export let height: string | number = "90%";
    export let open: boolean = false;
    export let closed: () => void = () => null;

    function close() {
        open = false;
        closed();
    }
</script>

<svelte:window on:keydown={(e) => e.key === 'Escape' && open && close()}></svelte:window>

{#if open}
    <article role="dialog" class="modal" style:width={width} style:height={height}>
        <slot/>
    </article>

    <div class="modal-overlay" on:pointerdown={() => close()}></div>
{/if}

<style>
    .modal {
        position: absolute;

        z-index: 5;

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
        z-index: 4;
    }
</style>