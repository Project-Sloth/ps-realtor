<script lang="ts">
    export let open: boolean = false;
    export let closed: () => void = () => null;

    function close() {
        open = false;
        closed();
    }
</script>

<svelte:window on:keydown={(e) => e.key === 'Escape' && open && close()}></svelte:window>

{#if open}
    <article role="dialog" class="modal">
        <slot/>
    </article>

    <div class="modal-overlay" on:pointerdown={() => close()}></div>
{/if}

<style>
    .modal {
        position: absolute;

        width: 60%;
        height: 90%;        

        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);

        z-index: 5;
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

    @media only screen and (max-width: 1279px) {
        .modal {
            width: 80%;
        }
	}
</style>