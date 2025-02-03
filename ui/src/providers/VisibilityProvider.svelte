<script lang="ts">
	import { onMount } from 'svelte'
	import { visibility } from '../store/stores'
	import { ReceiveNUI } from '../utils/ReceiveNUI'
	import { SendNUI } from '../utils/SendNUI'

	let isVisible: boolean

	visibility.subscribe((visible: boolean) => {
		isVisible = visible
	})

	ReceiveNUI<boolean>('setVisible', (visible: boolean) => {
		visibility.set(visible)
	})

	onMount(() => {
		const keyHandler = (e: KeyboardEvent) => {
			if (isVisible && ['Escape'].includes(e.code)) {
				SendNUI('hideUI')
				visibility.set(false)
			}
		}

		window.addEventListener('keydown', keyHandler)

		return () => window.removeEventListener('keydown', keyHandler)
	})
</script>

{#if isVisible}
	<main>
		<slot />
	</main>
{/if}

<style>
	main {
		display: grid;
		place-items: center;
		height: 100vh;
	}
</style>
