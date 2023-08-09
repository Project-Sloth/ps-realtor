<script lang="ts">
	import ApartmentCard from './ApartmentCard.svelte'
	import ApartmentModal from './ApartmentModal.svelte'
	import type { IApartment } from '@typings/type'
	import { APARTMENTS } from '@store/stores'

	let selectedApartment: IApartment  = null

</script>

{#if selectedApartment}
	<ApartmentModal bind:selectedApartment />
{/if}
{#key $APARTMENTS}
	<div
		class="w-full h-full pt-[2rem] gap-[0rem] z-[10] items-center flex flex-col"
	>
		<!-- ACTUAL CONTENT -->
		<div
			class="w-full h-full relative flex py-[5rem] pb-[8rem] flex-row flex-grow flex-shrink gap-4 flex-wrap items-start justify-center overflow-y-scroll scroll-style scroll-style-vertical"
		>
			{#each $APARTMENTS as apartment, i}
				<ApartmentCard bind:selectedApartment {apartment} />
			{/each}
		</div>
	</div>
{/key}
