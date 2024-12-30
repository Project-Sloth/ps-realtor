<script lang="ts">
    export let icon: string = 'fa-truck-front';
    export let text: string = '';
    export let border: boolean = false;
</script>

<article class="tile" class:border={border}>
    <i class="fas {icon}"/>
    <slot>{text}</slot>
</article>

<style>
    :root {
        --tile-color: #242424;
        --tile-icon-color: #ffffff4d;
        --tile-border-color: #ffffff4d;
    }

    .tile {
        display: flex;
        flex-direction: row;
        place-items: center;

        width: fit-content;

        padding: .25rem .5rem;
        gap: .5rem;
        border-radius: 3px;

        background-color: var(--tile-color);   
    }

    .tile.border {
        border: 1px solid var(--tile-border-color);
    }

    .tile > i {
        color: var(--tile-icon-color);
    }
</style>