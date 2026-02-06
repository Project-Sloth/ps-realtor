<script lang="ts">
	export let prefix = '';
	export let value: string;
	export let valid: boolean;
</script>

<article class="validation-indicator" class:valid>
	<i class="fas fa-circle small" />
	<p><span class="validation-indicator-prefix">{prefix}{prefix ? ': ' : ''}</span>{value}</p>
</article>

<style>
	.validation-indicator {
		display: flex;
		flex-direction: row;
		place-items: center;
		gap: 0.5rem;

		width: min-content;
		white-space: nowrap;

		border: 1px solid var(--light-border-color-2);
		border-radius: 3px;
		padding: .25rem .5rem;
		
		background: var(--control-background-gradient);
	}

	.validation-indicator > p {
		font-weight: 500;
		color: var(--white-color);
	}

	.validation-indicator-prefix {
		font-weight: 400;
		color: var(--less-light-border-color);
	}

	.validation-indicator > i {
		font-size: 0.5rem;
		width: 0.5rem;
		color: var(--red-color);
	}

	.validation-indicator.valid > i {
		color: var(--green-color);
	}
</style>
