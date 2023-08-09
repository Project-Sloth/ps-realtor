<script lang="ts">
	import type { IProperty } from '@typings/type'
	import { SendNUI } from '@utils/SendNUI'
	import { REALTOR_GRADE } from '@store/stores'

	export let selectedProperty: IProperty = null
</script>

{#if selectedProperty}
	<div class="flex flex-col gap-8 h-fit mb-4">
		<div class="flex flex-col gap-1">
			<p class="text-3xl font-bold">Description</p>
			<p class="text-2xl">{selectedProperty.description}</p>
		</div>
		<div class="flex flex-row gap-1">
			<div
				class="bg-[color:var(--color-tertiary)] grid place-items-center p-2 px-4"
			>
				{selectedProperty.owner ? 'Owned' : 'Not Owned'}
			</div>
			{#if $REALTOR_GRADE !== null && selectedProperty.for_sale}
				<div
					class="w-fit p-2 px-4 bg-[color:var(--color-tertiary)] items-center justify-center flex flex-row gap-4"
				>
					<i class="fas fa-dollar-sign" />
					<p>For Sale</p>
				</div>
			{/if}
		</div>

		<div class="flex flex-row gap-2">
			<p class="text-2xl font-bold">Price</p>
			<p class="text-2xl">${selectedProperty.price.toLocaleString()}</p>
		</div>

		<div class="flex flex-row gap-2">
			<p class="text-2xl font-bold">Shell</p>
			<p class="text-2xl">{selectedProperty.shell}</p>
		</div>

		<div class="flex flex-row gap-2 items-center">
			<p class="text-2xl font-bold">Garage</p>
			<div
				class="bg-[color:var(--color-tertiary)] aspect-square grid place-items-center p-2"
			>
				<i
					class="fas text-2xl fa-{selectedProperty.garage_data
						? 'check'
						: 'times'} text-2xl"
				/>
			</div>
		</div>

		<button
			class="flex flex-row gap-2 w-fit px-4 py-2 items-center bg-[color:var(--color-tertiary)]"
			on:click={() => {
				SendNUI('setWaypoint', selectedProperty.door_data)
			}}
		>
			<i class="fa-solid fa-location-dot" />
			<p class="text-2xl font-bold">Set Waypoint</p>
		</button>
	</div>
{/if}
