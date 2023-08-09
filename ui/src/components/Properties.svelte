<script lang="ts">
	import type { IProperty } from '@typings/type'
	import { afterUpdate, onDestroy, onMount } from 'svelte'
	import Sorter from './Sorter.svelte'
	import { fly } from 'svelte/transition'
	import PropertyModal from './PropertyModal.svelte'
	import CreateCard from './CreateCard.svelte'
	import PropertyCard from './PropertyCard.svelte'
	import { CONFIG, REALTOR_GRADE } from '@store/stores'

	let Properties: IProperty[] = []
	let selectedProperty: IProperty | null = null

	let El: HTMLElement // The element that will be scrolled
	let initial: boolean = true // If the scroll position has been set
	afterUpdate(() => {
		// Get the scroll position from the session storage
		if (initial) {
			initial = false
			const scrollPosition =
				sessionStorage.getItem('propertiesScrollPosition') || 0
			// If there is a scroll position, scroll to it
			if (scrollPosition) {
				El.scrollTop = parseInt(scrollPosition)
			}
		}
	})

	onDestroy(() => {
		const scrollTop = El.scrollTop
		sessionStorage.setItem('propertiesScrollPosition', scrollTop.toString())
	})

	let isCreating: boolean = false

</script>

{#if selectedProperty}
	<PropertyModal bind:selectedProperty />
{/if}

<div
	class="w-full h-full pt-[2rem] gap-[0rem] z-[10] items-center flex flex-col"
>
	<Sorter bind:Properties />

	{#if $REALTOR_GRADE >= $CONFIG.listNewProperty}
		<div
			class="flex flex-row gap-2 items-center w-fit px-6 py-2 justify-center bg-[color:var(--color-secondary)]"
			in:fly={{ y: 10, duration: 250 }}
		>
			<p class="text-2xl font-bold">List New Property</p>
			<div class="flex flex-row w-fit gap-4 items-center justify-center">
				<button
					class="bg-[color:var(--color-tertiary)] w-12 flex flex-row items-center justify-center gap-2 p-2"
					on:click={() => (isCreating = !isCreating)}
				>
					<i class="fas fa-caret-{isCreating ? 'up' : 'down'}" />
				</button>
			</div>
		</div>
	{/if}
	{#if isCreating}
		<CreateCard bind:isCreating />
	{/if}

	<!-- ACTUAL CONTENT -->
	<div
		bind:this={El}
		class="w-full h-full relative flex py-[5rem] pb-[8rem] flex-row flex-grow flex-shrink gap-4 flex-wrap items-start justify-center overflow-y-scroll scroll-style scroll-style-vertical"
	>
		{#if Properties && Properties.length > 0}
			{#each Properties as property, i}
				<PropertyCard bind:selectedProperty {property} />
			{/each}
		{:else}
			<p class="text-2xl font-bold">No Properties Found</p>
		{/if}
	</div>
</div>
