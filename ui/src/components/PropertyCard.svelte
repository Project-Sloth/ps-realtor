<script lang="ts">
	import type { IProperty } from '@typings/type'
	import { REALTOR_GRADE, SHELLS } from '@store/stores'
	import { fly } from 'svelte/transition'

	export let selectedProperty: IProperty = null
	export let property: IProperty = null
</script>

<button
	class="flex item flex-col w-[30%] h-fit bg-[color:var(--color-secondary)] z-[10]"
	on:click={() => (selectedProperty = property)}
	in:fly={{ y: 10, duration: 250 }}
>

	{#if property.extra_imgs[0] ? property.extra_imgs[0].url : $SHELLS[property.shell].imgs[0].url}
		<img
			src={property.extra_imgs[0]
				? property.extra_imgs[0].url
				: $SHELLS[property.shell].imgs[0].url}
			alt=""
			class="w-full h-[20rem] object-cover object-center"
		/>
	{:else}
		<img
			src="https://via.placeholder.com/150"
			alt=""
			class="w-full h-[20rem] object-cover object-center"
		/>
	{/if}



	<div
		class="flex flex-col flex-grow flex-shrink gap-4 p-4 justify-center w-full"
	>
		<h1 class="text-2xl font-bold">{property.street || property.apartment} {property.property_id}</h1>
		{#if property.region}
			<p class="text-xl">{property.region}</p>
		{/if}
		<!-- Chips -->
		<div
			class="flex flex-row flex-grow flex-wrap flex-shrink gap-4 items-center justify-center"
		>
		<div class="w-fit px-4 h-[3rem] bg-[color:var(--color-tertiary)] grid place-content-center z-40 top-0 left-0">
			<p class="text-xl">{property.property_id}</p>
		</div>
		
			{#if $REALTOR_GRADE >= 0 && property.for_sale}
				<div
					class="w-fit px-4 h-[3rem] bg-[color:var(--color-tertiary)] items-center justify-center flex flex-row gap-4"
				>
					<i class="fas fa-dollar-sign" />
					<p>For Sale</p>
				</div>
			{/if}
			
			{#if property.price}
				<div
					class="w-fit px-4 h-[3rem] bg-[color:var(--color-tertiary)] items-center justify-center flex flex-row gap-4"
				>
					<i class="fas fa-dollar-sign" />
					<p>{property.price?.toLocaleString()}</p>
				</div>
			{/if}

			<div
				class="w-fit px-4 h-[3rem] bg-[color:var(--color-tertiary)] items-center justify-center flex flex-row gap-4"
			>
				<i class="fas fa-image" />
				<p>
					{$SHELLS[property.shell]
						? $SHELLS[property.shell].imgs.length
						: 0}
				</p>
			</div>
			<div
				class="w-fit px-4 h-[3rem] bg-[color:var(--color-tertiary)] items-center justify-center flex flex-row gap-4"
			>
				<i class="fas fa-tent" />
				<p>{property.shell}</p>
			</div>
			<div
				class="w-fit px-4 h-[3rem] bg-[color:var(--color-tertiary)] items-center justify-center flex flex-row gap-4"
			>
				<i class="fas fa-warehouse" />
				<p>
					{property.garage_data
						? Object.keys(property.garage_data).length > 0
							? 'Yes'
							: 'No'
						: 'No'}
				</p>
			</div>
		</div>
	</div>
</button>

<style>
	.item {
		border: 5px solid var(--color-secondary);
	}
</style>
