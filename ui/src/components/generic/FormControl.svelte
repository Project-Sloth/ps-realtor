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

    .form-control-content > :global(input) {
        width: 10rem;
        padding: .25rem .5rem;

        border: 1px solid var(--light-border-color-2);
        border-radius: 3px;

        background: var(--control-background-gradient);
    }

    .form-control-content > :global(input[type="number"]::-webkit-outer-spin-button),
    .form-control-content > :global(input[type="number"]::-webkit-inner-spin-button),
    .form-control-content > :global(input[type="number"]) {
        -webkit-appearance: none;
        margin: 0;
        -moz-appearance: textfield !important;
    }

    .form-control-content > :global(textarea) {
        width: 10rem;
        padding: .25rem .5rem;

        border: 1px solid var(--light-border-color-2);
        border-radius: 3px;

        background: var(--control-background-gradient);
    }


</style>