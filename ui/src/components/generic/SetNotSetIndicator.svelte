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
	<p class="left-value">{displayLeftValue}</p>
	<p class="right-value">{rightValue}</p>
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

		font-size: 0.5vw;

		display: flex;
		flex-direction: row;

		text-align: center;
	}

	.set-not-set-wrapper > .left-value {
		font-weight: 400;
		color: var(--less-light-border-color);
	}

	.set-not-set-wrapper > .right-value {
		font-weight: 500;
		color: var(--white-color);
		margin-left: 0.3vw;
	}

	.set-not-set-wrapper > .indicator {
		font-size: 0.3vw;
		padding-top: 0.3vw;
		margin-right: 0.3vw;
	}
</style>
