<script lang="ts">
    export let icon: string = 'fa-truck-front';
    export let text: string = '';
</script>

<article class="tile">
    <i class="fas {icon}"/>
    <slot>{text}</slot>
</article>

<style>
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

    .tile > i {
        color: var(--less-light-border-color);
    }
</style>