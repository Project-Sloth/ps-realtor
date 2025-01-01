<script lang="ts">
    export let label: string;
    export let controlId: string;
</script>

<div class="form-control">
    <label for={controlId}>{label}</label>

    <div class="form-control-content">
        <slot></slot>
    </div>    
</div>

<style>
    .form-control {
        display: flex;
        flex-direction: column;
        gap: .25rem;
    }

    .form-control-content {
        display: flex;
        flex-direction: row;
        gap: 1rem;
        place-items: center;
    }

    .form-control > label {
        @apply text-sm;
        font-weight: 500;
    }
    
    .form-control-content > :global(input),
    .form-control-content > :global(textarea),
    :global(input.form-control),
    :global(textarea.form-control) {
        min-width: 0;
        width: 12rem;

        padding: .25rem .5rem;

        border: 1px solid var(--light-border-color-2);
        border-radius: 3px;

        background: var(--control-background-gradient);
    }

    .form-control-content > :global(input[type="number"]::-webkit-outer-spin-button),
    .form-control-content > :global(input[type="number"]::-webkit-inner-spin-button),
    .form-control-content > :global(input[type="number"]),
    :global(input[type="number"].form-control::-webkit-outer-spin-button),
    :global(input[type="number"].form-control::-webkit-inner-spin-button),
    :global(input[type="number"].form-control) {
        -webkit-appearance: none;
        margin: 0;
        -moz-appearance: textfield !important;
    }
</style>