<script lang="ts">
    export let id: string | null = null;
    export let text: string = '';
    export let icon: string = '';
    export let type: 'button' | 'submit' | 'reset' = 'button';
    export let status: 'basic' | 'primary' | 'success' | 'danger' | 'none' = 'basic';
    export let justify: 'center' | 'start' | 'end' | 'between' | 'even' | 'none' = 'none';
    export let style: 'basic' | 'outline' = 'basic';
    export let disabled: boolean = false;
    export let block: boolean = false;
    export let active: boolean = false;
    export let ariaLabel: string | null = null;
    export let click: (event: MouseEvent) => void = () => null;

    if (block && justify == 'none')
        justify = 'center';
</script>

<button {id} {type} {disabled}
    class="btn status-{status} justify-{justify} style-{style}"
    class:icon={icon && !$$slots.default && !text}
    class:block
    class:active
    aria-label={ariaLabel}
    on:click={click}>
    {#if icon}
    <i class="fas {icon}"/>
    {/if}
    <slot>{text}</slot>
</button>

<style>
    .btn {
        display: flex;
        flex-direction: row;
        gap: .5rem;        

        text-align: center;
        place-items: center;

        width: fit-content;

        border-radius: 3px;
        padding: .25rem .75rem;

        font-weight: 500;
    }

    .btn:hover:not(:disabled),
    .btn.active {
        filter: brightness(1.1);
    }

    .btn:disabled {
        filter: brightness(0.8);
    }

    .btn.status-basic {
        background: var(--light-border-color);
        border: 1px solid var(--light-border-color-2);
    }

    .btn.status-basic:hover:not(:disabled) {
        color: rgba(255, 255, 255, 0.95);
		border: 1px solid var(--light-border-color-6);
    }

    .btn.status-primary {
        background: var(--blue-color);
        border: 1px solid var(--blue-color);
    }

    .btn.status-success {
        background: var(--green-color);
        border: 1px solid var(--green-color);
    }

    .btn.status-danger {
        background-color: var(--red-color);
        border: 1px solid var(--red-color);
    }

    .btn.status-none {
        background: unset;
        border: 1px solid transparent;
    }

    .btn.justify-center { justify-content: center; }
    .btn.justify-start { justify-content: start; }
    .btn.justify-end { justify-content: end; }
    .btn.justify-between { justify-content: space-between; }
    .btn.justify-even { justify-content: space-evenly; }

    .btn.style-outline:not(:hover) { background: unset; }

    .btn.block {
        width: 100%;
    }

    .btn.icon {
        padding: .5rem;
    }

</style>