<script lang="ts">
	import type { IApartment, IProperty } from '@typings/type'
	import { fly } from 'svelte/transition'

	export let selectedApartment: IApartment = null
	export let apartment: IApartment = null

	// cbf with typescript rn
	let apartmentData: any = apartment.apartmentData
</script>

<button
	class="flex item flex-col w-[30%] h-fit bg-[color:var(--color-secondary)] z-[10]"
	on:click={() => (selectedApartment = apartment)}
	in:fly={{ y: 10, duration: 250 }}
>
	<img
		src={apartmentData.imgs[0].url}
		alt=""
		class="w-full h-[20rem] object-cover object-center"
	/>
	<div
		class="flex flex-col flex-grow flex-shrink gap-4 p-4 justify-center w-full"
	>
		<h1 class="text-2xl font-bold">{apartmentData.label}</h1>
		<!-- Chips -->
		<div
			class="flex flex-row flex-grow flex-wrap flex-shrink gap-4 items-center justify-center"
		>
			<div
				class="w-fit px-4 h-[3rem] bg-[color:var(--color-tertiary)] items-center justify-center flex flex-row gap-4"
			>
				<i class="fas fa-building" />
				<p>{Object.keys(apartment.apartments).length || 0}</p>
			</div>
		</div>
	</div>
</button>

<style>
	.item {
		border: 5px solid var(--color-secondary);
	}
</style>
