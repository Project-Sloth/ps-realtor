<script lang="ts">
	import Dropdown, { type LabelValue } from '@components/generic/Dropdown.svelte'
	import PropertyCard from '@components/properties/PropertyCard.svelte'
	import { PROPERTIES } from '@store/stores'
	import type { Property } from '@typings/type'
	import { SendNUI } from '@utils/SendNUI'
	import ManagePropertyModal from './ManagePropertyModal.svelte'
	import PropertyDetailsModal from './PropertyDetailsModal.svelte'

	type PropertyFilter = 'all' | 'house' | 'apartment';
	type SaleFilter = 'all' | 'sale';
	type PriceFilter = 'asc' | 'desc';

	const priceOptions: LabelValue<PriceFilter>[] = [
		{ label: 'High to Low', value: 'desc' }, 
		{ label: 'Low to High', value: 'asc' }
	];

	let selectedPriceOption = 'desc';

	const saleOptions: LabelValue<SaleFilter>[] = [
		{ label: 'All Properties', value: 'all' },
		{ label: 'For Sale', value: 'sale' }, 		
	];

	let selectedSaleOption: SaleFilter = 'sale';

	const propertyTypeOptions: LabelValue<PropertyFilter>[] = [
		{ label: 'All', value: 'all' },
		{ label: 'House', value: 'house' },
		{ label: 'Apartments', value: 'apartment' },
	];

	let selectedPropertyType: PropertyFilter = 'all';

	let selectedProperty: Property | undefined = undefined;
	let manageProperty: boolean = false;

	let searchTerm = '',
		filteredProperties: Property[] = []

	PROPERTIES.subscribe((value) => {
		if (value) {
			filter()
		}
	})

	function filter() {
		filteredProperties = []

		setTimeout(() => {
			let properties: Property[] = $PROPERTIES
			properties = filterForSale(properties)
			properties = filterPriceSort(properties)
			properties = filterSearch(properties)
			filteredProperties = filterProperties(properties)
		}, 1)
	}

	function filterProperties(properties: Property[]) {
		if (selectedPropertyType === 'all')
			return properties;
		
		return properties.filter(property => 
			selectedPropertyType === 'house' ? !property.apartment : 
			selectedPropertyType === 'apartment' ? !!property.apartment : false);
	}

	function filterForSale(properties: Property[]) {
		// filter properties that have for_sale = 1 or true
		if (selectedSaleOption === 'all') return properties

		properties = properties.filter((property) => property.for_sale)

		return properties
	}

	function filterSearch(properties: Property[]) {
		if (searchTerm.length < 1) return properties

		properties = properties.filter((property) => {
			const streetFilter = property.street
				? property.street
						.toLowerCase()
						.includes(searchTerm.toLowerCase())
				: false

			const regionFilter = property.region
				? property.region
						.toLowerCase()
						.includes(searchTerm.toLowerCase())
				: false

			const descriptionFilter = property.description
				.toLowerCase()
				.includes(searchTerm.toLowerCase())

			const shellFilter = property.shell
				.toLowerCase()
				.includes(searchTerm.toLowerCase())

			const apartmentFilter = property.apartment
				? property.apartment
						.toLowerCase()
						.includes(searchTerm.toLowerCase())
				: false

			const propertyNumberFilter =
				property.property_id
					.toString()
					.includes(searchTerm.toLowerCase()) ?? false

			return (
				streetFilter ||
				descriptionFilter ||
				shellFilter ||
				regionFilter ||
				apartmentFilter ||
				propertyNumberFilter
			)
		})

		return properties
	}

	function filterPriceSort(properties: Property[]) {
		if (selectedPriceOption === priceOptions[1].value) {
			// low to high
			properties = properties.sort((a, b) => a.price - b.price)
		} else {
			properties = properties.sort((a, b) => b.price - a.price)
		}

		return properties
	}

	function deleteProperty(event) {
		const propertyToDelete = event.detail

		if (propertyToDelete == null) return

		SendNUI('updatePropertyData', {
			type: 'DeleteProperty',
			property_id: propertyToDelete.property_id,
			data: {},
		})

		const index = $PROPERTIES.findIndex(
			(property) => property.property_id === propertyToDelete.property_id
		)

		$PROPERTIES.splice(index, 1)

		manageProperty = false
		selectedProperty = undefined;

		filter()
	}

	$: {
		if (searchTerm || searchTerm?.trim() === '') {
			filter()
		}
	}
</script>

<div class="property-container">
	<section class="property-search">
		<img src="images/properties-banner.webp" alt="Properties Banner" />

		<div class="property-search-content">
			<h1>Find your next property purchase</h1>
			<p class="text-lg">
				From houses, to garages, to the best sales.
			</p>

			<div class="property-search-bar">
				<input
					type="text"
					placeholder="Explore all real estate"
					bind:value={searchTerm}
				/>
				<i class="fas fa-magnifying-glass" />
			</div>
		</div>
	</section>

	<section class="property-filter">
		<h2>All Properties Listed</h2>

		<div class="spacer"></div>

		<Dropdown
			items={priceOptions}
			bind:value={selectedPriceOption}
			changed={() => filter()}
		/>

		<Dropdown
			items={saleOptions}
			bind:value={selectedSaleOption}
			changed={() => filter()}
			overflowX
		/>

		<Dropdown
			items={propertyTypeOptions}
			bind:value={selectedPropertyType}
			prefix="Type: "
			changed={() => filter()}
		/>
	</section>

	<section class="property-listings">
		{#key $PROPERTIES}			
			{#each filteredProperties as property, i}
				<PropertyCard
					id={'property-card-' + i}
					{property}
					selected={property => selectedProperty = property}
				/>
			{:else}
				<p class="empty">No properties found.</p>
			{/each}
		{/key}
	</section>

	{#if selectedProperty && !manageProperty}
		<PropertyDetailsModal bind:selectedProperty bind:manageProperty />
	{:else if selectedProperty && manageProperty}
		<ManagePropertyModal
			{selectedProperty}
			bind:manageProperty
			on:delete-property={(event) => deleteProperty(event)}
		/>
	{/if}
</div>

<style>
	.property-container {
		display: flex;
		flex-direction: column;
		gap: 1rem;	
		height: 100%;
	}

	.property-search {
		position: relative;
		border-radius: 4px;
	}

	.property-search > img {
		border-radius: 12px;
		max-height: 10rem;
		width: 100%;
		object-fit: cover;
	}

	.property-search-content {
		position: absolute;
		display: flex;
		flex-direction: column;
		place-items: center;
		place-content: center;


		width: 100%;
		height: 100%;

		z-index: 1;
		text-align: center;

		font-weight: 600;

		top: 0%;
	}

	.property-search-content > h1,
	.property-search-content > p {
		text-shadow: 2px 2px 2px #000;
	}

	.property-search-bar {
		width: 50%;
		display: flex;

		margin-top: 1rem;
		align-items: center;

		background-color: #fff;
		box-shadow: 0px 4px 4px 0px rgba(0, 0, 0, 0.1);
		border-radius: 3px;
		padding: 0 1rem;
		gap: 0.5rem;
	}

	.property-search-bar > input {
		width: 100%;
		height: 2.5rem;

		font-weight: 500;
		color: rgba(0, 0, 0, 1);
		background: none;
		border: none;
		@apply text-lg;
	}

	.property-search-bar > i {
		color: rgba(0, 0, 0, 0.6);
	}

	.property-filter {
		display: flex;
		place-items: center;
		gap: 1rem;
	}

	.property-filter > :global(.dropdown-container) {
		min-width: 8rem;
	}

	.property-listings {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(20rem, 1fr));
		grid-auto-rows: min-content;

		gap: 1rem;
		overflow-y: auto;

		flex: 1;
		padding: 0 1rem .5rem 1rem;
	}

	.property-listings:has(.empty) {
		grid-template-columns: 1fr;
		grid-auto-rows: 1fr;

        place-items: center;
        font-weight: 500;
    }
</style>