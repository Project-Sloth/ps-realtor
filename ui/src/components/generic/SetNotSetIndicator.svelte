<script>
	import { onMount } from 'svelte'

	export let leftValue = 'Set',
		rightValue = '',
		good = true,
		id = 'status-indicator'

	let displayLeftValue = ''

	onMount(() => {
		if (rightValue?.trim() !== '') {
			displayLeftValue = leftValue + ': '
		} else {
			displayLeftValue = leftValue
		}
	})
</script>

<div class="set-not-set-wrapper" {id}>
	<i class="fas fa-circle {good ? 'green' : 'red'} indicator" />
	<span class="left-value">{displayLeftValue} <span class="right-value">{rightValue}</span></span>
</div>

<style>
	.set-not-set-wrapper {
		min-width: 3vw;
		width: fit-content;

		border-radius: 0.13vw;
		background: linear-gradient(0deg, #313131, #313131),
			linear-gradient(
				0deg,
				var(--light-border-color-2),
				var(--light-border-color-2)
			);
		border: 1px solid var(--light-border-color-2);

		padding: 0.3vw 0.5vw;

		display: flex;
		flex-direction: row;

		align-items: center;
		gap: .5rem;
	}

	.set-not-set-wrapper > .left-value {
		font-weight: 400;
		color: var(--less-light-border-color);
	}

	.set-not-set-wrapper > .left-value > .right-value {
		font-weight: 500;
		color: var(--white-color);
	}

	.set-not-set-wrapper > .indicator {
		width: 0.5rem;
		font-size: 0.5rem;
	}
</style>
