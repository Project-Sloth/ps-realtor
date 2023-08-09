<script lang="ts">
	import type { IApartment, IProperty } from '@typings/type'
	import { SendNUI } from '@utils/SendNUI'

	export let selectedApartment: IApartment = null
    let apartmentData = selectedApartment.apartmentData
</script>

{#if selectedApartment}
	<div class="flex flex-col gap-8 h-fit mb-4">
		<button
			class="flex flex-row gap-2 w-fit px-4 py-2 items-center bg-[color:var(--color-tertiary)]"
			on:click={() => {
				SendNUI('setWaypoint', apartmentData.door)
			}}
		>
			<i class="fa-solid fa-location-dot" />
			<p class="text-2xl font-bold">Set Waypoint</p>
		</button>
	</div>
{/if}
