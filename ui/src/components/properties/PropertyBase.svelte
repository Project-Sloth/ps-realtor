<script lang="ts">
	import PropertyCard from '@components/properties/PropertyCard.svelte'
	import Dropdown from '@components/generic/Dropdown.svelte'
	import type { Property } from '@typings/type'
	import { PROPERTIES } from '@store/stores'
	import PropertyDetailsModal from './PropertyDetailsModal.svelte'
	import ManagePropertyModal from './ManagePropertyModal.svelte'
	import { SendNUI } from '@utils/SendNUI'

	const highLowDropdown = [
		{ label: 'High to Low', value: 'h2l' }, 
		{ label: 'Low to High', value: 'l2h' }
	];

	let selectedHighLowValue = highLowDropdown[0].value;

	const forSaleDropdown = [
		{ label: 'For Sale', value: 'sale' }, 
		{ label: 'All Properties', value: 'all' },
	];

	let selectedForSaleValue = forSaleDropdown[0].value;

	const typeDropdown = [
		{ label: 'House', value: 'house' },
		{ label: 'Apartments', value: 'apartment' },
	];

	let selectedTypeValue = typeDropdown[0].value;

	let selectedProperty: Property | null = null,
		manageProperty: boolean = false

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
			filteredProperties = filterApartment(properties)
		}, 1)
	}

	function filterApartment(properties: Property[]) {
		// filter properties that have for_sale = 1 or true
		if (selectedTypeValue === typeDropdown[1].value) return properties // include apartments (all properties)

		properties = properties.filter((property) => !property.apartment)

		return properties
	}

	function filterForSale(properties: Property[]) {
		// filter properties that have for_sale = 1 or true
		if (selectedForSaleValue === forSaleDropdown[1].value) return properties

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
		if (selectedHighLowValue === highLowDropdown[1].value) {
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
			property_id: selectedProperty.property_id,
			data: {},
		})

		const index = $PROPERTIES.findIndex(
			(property) => property.property_id === propertyToDelete.property_id
		)

		$PROPERTIES.splice(index, 1)

		manageProperty = false
		selectedProperty = null

		filter()
	}

	$: {
		if (searchTerm || searchTerm?.trim() === '') {
			filter()
		}
	}
</script>

<div class="properties-base">
	<div class="search-wrapper">
		<img src="images/apts-bg.png" alt="Apartments Background" />

		<div class="search-data">
			<h1>Find your next property purchase</h1>
			<p class="text-lg">
				From houses, to garages, to the best sales.
			</p>

			<div class="search-bar">
				<input
					type="text"
					placeholder="Explore all real estate"
					bind:value={searchTerm}
				/>
				<i class="fas fa-magnifying-glass" />
			</div>
		</div>
	</div>

	<div class="properties-heading-wrapper">
		<p class="heading">All Properties Listed</p>

		<div class="filters-wrapper">

			<Dropdown
				items={highLowDropdown}
				bind:value={selectedHighLowValue}
				changed={() => filter()}
			/>

			<Dropdown
				items={forSaleDropdown}
				bind:value={selectedForSaleValue}
				changed={() => filter()}
			/>

			<Dropdown
				items={typeDropdown}
				bind:value={selectedTypeValue}
				prefix="Type: "
				changed={() => filter()}
			/>
		</div>
	</div>

	{#key $PROPERTIES}
		<div class="property-listing-wrapper" style="margin-top: 2.5vw;">
			{#each filteredProperties as property, i}
				<PropertyCard
					id={'property-card-' + i}
					{property}
					bind:selectedProperty
				/>
			{/each}
		</div>
	{/key}

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
