<script lang="ts">
    export let id: string | null = null;
    export let text: string = '';
    export let icon: string = '';
    export let status: 'basic' | 'primary' | 'success' | 'danger' = 'basic';
    export let type: "button" | "submit" | "reset" = 'button';
    export let disabled: boolean = false;
    export let block: boolean = false;
    export let click: (event: MouseEvent) => void = () => null;
</script>

<button {id} class="btn {status}" class:block {type} {disabled} on:click={click}>
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

    .btn.basic {
        background: var(--light-border-color);
        border: 1px solid var(--light-border-color-2);
    }

    .btn.basic:hover:not(:disabled) {
        color: rgba(255, 255, 255, 0.95);
		border: 1px solid var(--light-border-color-6);
    }

    .btn.primary {
        background: var(--blue-color);
        border: 1px solid var(--blue-color);
    }

    .btn.success {
        background: var(--green-color);
        border: 1px solid var(--green-color);
    }

    .btn.danger {
        background-color: var(--red-color);
        border: 1px solid var(--red-color);
    }

    .btn:hover:not(:disabled) {
        filter: brightness(1.1);
    }

    .btn:disabled {
        filter: brightness(0.8);
    }

    .btn.block {
        width: 100%;
        justify-content: center;
    }
</style>