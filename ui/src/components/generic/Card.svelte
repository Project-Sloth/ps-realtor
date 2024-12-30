<script lang="ts">
    export let title = "";
</script>

<article class="card">
    <header class="card-header">
        <slot name="icon"></slot>
        <h1>{title}</h1>
        <div class="spacer"></div>
        <slot name="header-action"></slot>
    </header>

    <section class="card-body">
        <slot></slot>
    </section>

    <footer class="card-footer">
        <slot name="footer"></slot>
    </footer>
</article>

<style>
    .card {
        display: flex;
        flex-direction: column;
        height: 100%;

        background: linear-gradient(0deg, #242424, #242424), linear-gradient(0deg, var(--light-border-color), var(--light-border-color));

        border-width: 0px, 1px, 1px, 1px;
        border-style: solid;
        border-color: var(--light-border-color);
    }

    .card-header {
        display: flex;
        flex-direction: row;
        place-items: center;
        gap: .5rem;
        
        padding: 0.5rem 1rem;
        border-bottom: 0.1px solid var(--light-border-color);
    }

    .card-body {
        position: relative;

        display: flex;
        flex-direction: var(--card-body-direction, column);
        gap: var(--card-body-gap, 1rem);

        flex: 1;
        overflow-y: auto;
        padding: 1rem 2rem;
    }

    .card-footer {
        display: flex;
        flex-direction: row;
        justify-content: flex-end;

        background-color: var(--footer-color);
        padding: 0.5rem 1rem;
    }
</style>