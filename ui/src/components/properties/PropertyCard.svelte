<script lang="ts">
	import Image from '@components/generic/Image.svelte'
import Tile from '@components/generic/Tile.svelte'
	import { REALTOR_GRADE, SHELLS } from '@store/stores'
	import type { Property } from '@typings/type'

	export let id = 'property-card-1';
	export let property: Property;
	export let selected: (property: Property) => void;

	$: thumbnail = property.extra_imgs[0] ? property.extra_imgs[0] : $SHELLS[property.shell].imgs[0];
</script>

<button {id} class="property-card" on:click={() => selected(property)}>
	<header class="property-card-header">
		{#if thumbnail}
			<Image src={thumbnail.url} alt={thumbnail.label} fallback="images/fallback-image.svg"></Image>
		{:else}
			<!-- svelte-ignore a11y-img-redundant-alt -->
			<img
				src="images/property-card.webp"
				alt="Default Property Card Image"
			/>
		{/if}
		<div class="img-backdrop">
			View Property
		</div>
	</header>

	<section class="property-card-content">
		<h2 class="property-name">
			{property.property_id}
			{property.street ? property.street : 
				property.apartment ? property.apartment	: ''}
		</h2>
		<small style="color: var(--light-border-color-8);">{property.region ? property.region : 'Los Santos'}</small>

		<div class="property-card-details">
			{#if !property.apartment}
				<Tile icon="fa-landmark">${property.price?.toLocaleString()}</Tile>
			{/if}
			
			{#if $REALTOR_GRADE >= 0 && property.for_sale}
				<Tile icon="fa-sign-hanging">For Sale</Tile>
			{/if}

			<Tile icon="fa-image">
				Gallery: {$SHELLS[property.shell] ? $SHELLS[property.shell].imgs.length : 0}
			</Tile>

			<Tile icon="fa-kitchen-set">{property.shell === 'mlo' ? 'MLO Interior' : property.shell}</Tile>

			<Tile icon={property.apartment ? 'fa-building' : 'fa-house-chimney'}>{property.apartment ? 'Apartment' : 'House'}</Tile>

			{#if property.garage_data && Object.keys(property.garage_data).length > 0}
				<Tile icon="fa-truck-front">Garage</Tile>
			{/if}

			{#if !property.apartment && property.shell !== 'mlo' && property.zone_data && Object.keys(property.zone_data).length > 0}
				<Tile icon="fa-tree">Garden</Tile>
			{/if}
		</div>
	</section>
</button>

<style>
	.property-card {
		display: flex;
		flex-direction: column;

		border-radius: 3px;
		box-shadow: 0px 4px 4px 0px rgba(0, 0, 0, 0.25);

		background-color: var(--light-border-color-2);
		transition: transform .15s ease-out;

		text-align: unset;
	}

	.property-card:hover {
		display: flex;
		transform: scale(0.97) translateZ(0);

		transition: transform .2s ease-in;

		-webkit-font-smoothing: antialiased;
		filter: unset;
	}

	.property-card-header {
		position: relative;
		width: 100%;
	}

	.property-card-header > :global(img) {
		border-radius: 3px 3px 0 0;
        object-fit: cover;
        width: 100%;
        height:13rem;
	}

	.property-card-content {
		flex: 1;
		display: flex;
		flex-direction: column;

		padding: 0.5rem 1rem;
	}

	.property-card-details {
		margin-top: 0.5rem;
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
	}

	.property-card:hover > .property-card-header > .img-backdrop {
		height: 100%;
		visibility: visible;
	}

	.property-card-header > .img-backdrop {
		position: absolute;

		top: 0%;

		width: 100%;
		height: 0%;

		display: grid;
		place-items: center;

		background-color: var(--black-opaque-color-3);
		@apply text-xl;

		color: var(--white-color);
		backdrop-filter: blur(2px);

		visibility: hidden;
	}
</style>