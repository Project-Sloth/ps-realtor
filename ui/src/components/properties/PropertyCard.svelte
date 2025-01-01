<script lang="ts">
	import Tile from '@components/generic/Tile.svelte'
	import { REALTOR_GRADE, SHELLS } from '@store/stores'
	import type { Property } from '@typings/type'

	export let id = 'property-card-1';
	export let property: Property;
	export let selected: (property: Property) => void;
</script>

<button {id} class="property-card group" on:click={() => selected(property)}>
	<header class="property-card-header relative">
		{#if property.extra_imgs[0] ? property.extra_imgs[0].url : $SHELLS[property.shell].imgs[0].url}
			<img
				src={property.extra_imgs[0]
					? property.extra_imgs[0].url
					: $SHELLS[property.shell].imgs[0].url}
				alt=""
			/>
		{:else}
			<!-- svelte-ignore a11y-img-redundant-alt -->
			<img
				src="images/property-card-img.png"
				alt="Default Property Card Image"
			/>
		{/if}
		<div class="invisible h-0 w-full absolute group-hover:visible group-hover:h-full grid place-items-center img-backdrop"		>
			View Property
		</div>
	</header>

	<section class="property-card-content">
		<h2 class="property-name">
			{property.property_id}
			{property.street
				? property.street + ' — '
				: property.apartment
				? property.apartment + ' — '
				: 'Zancudo Ave'}
		</h2>
		<small style="color: var(--light-border-color-8);">{property.region ? property.region : 'Sandy Shores'}</small>

		<div class="property-card-details">
			<Tile icon="fa-landmark">
				${property.price?.toLocaleString()}
			</Tile>
			
			{#if $REALTOR_GRADE >= 0 && property.for_sale}
				<Tile icon="fa-sign-hanging">
					For Sale
				</Tile>
			{/if}

			<Tile icon="fa-image">
				Gallery: {$SHELLS[property.shell] ? $SHELLS[property.shell].imgs.length : 0}
			</Tile>

			<Tile icon="fa-house-chimney">{property.shell}</Tile>

			{#if property.garage_data && Object.keys(property.garage_data).length > 0}
				<Tile icon="fa-truck-front">Garage</Tile>
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
		width: 100%;
	}

	.property-card-header > img {
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

	.property-card-header > .img-backdrop {
		top: 0%;
		height: 100%;
		background-color: var(--black-opaque-color-3);
		@apply text-xl;

		color: var(--white-color);
		backdrop-filter: blur(2px);

		place-items: center;
	}
</style>