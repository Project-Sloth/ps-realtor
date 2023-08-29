<script lang="ts">
	import PropertyCard from '@components/properties/PropertyCard.svelte'
	import DropdownComponent from '@components/generic/DropdownComponent.svelte'
	import type { IProperty } from '@typings/type'
	import { PROPERTIES } from '@store/stores'
	import PropertyDetailsModal from './PropertyDetailsModal.svelte'
	import ManagePropertyModal from './ManagePropertyModal.svelte'
	import { SendNUI } from '@utils/SendNUI'

	const highLowDropdown = ['High to Low', 'Low to High']
	let selectedHighLowValue = highLowDropdown[0]

	const forSaleDropdown = ['For Sale', 'All Properties']
	let selectedForSaleValue = forSaleDropdown[0]

	const typeDropdown = ['House', 'Apartments']
	let selectedTypeValue = typeDropdown[0]

	let selectedProperty: IProperty | null = null,
		manageProperty: boolean = false

	let searchTerm = '',
		filteredProperties: IProperty[] = []

	PROPERTIES.subscribe((value) => {
		if (value) {
			filter()
		}
	})

	function filter() {
		filteredProperties = []

		setTimeout(() => {
			let properties: IProperty[] = $PROPERTIES
			properties = filterForSale(properties)
			properties = filterPriceSort(properties)
			properties = filterSearch(properties)
			filteredProperties = filterApartment(properties)
		}, 1)
	}

	function filterApartment(properties: IProperty[]) {
		// filter properties that have for_sale = 1 or true
		if (selectedTypeValue === typeDropdown[1]) return properties // include apartments (all properties)

		properties = properties.filter((property) => !property.apartment)

		return properties
	}

	function filterForSale(properties: IProperty[]) {
		// filter properties that have for_sale = 1 or true
		if (selectedForSaleValue === forSaleDropdown[1]) return properties

		properties = properties.filter((property) => property.for_sale)

		return properties
	}

	function filterSearch(properties: IProperty[]) {
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

	function filterPriceSort(properties: IProperty[]) {
		if (selectedHighLowValue === highLowDropdown[1]) {
			// low to high
			properties = properties.sort((a, b) => a.price - b.price)
		} else {
			properties = properties.sort((a, b) => b.price - a.price)
		}

		return properties
	}

	function handleDropDownSelections(key, value) {
		if (key === 'high-low') {
			selectedHighLowValue = value
		}

		if (key === 'for-sale') {
			selectedForSaleValue = value
		}

		if (key === 'type') {
			selectedTypeValue = value
		}

		filter()
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
			<p>Find your next property purchase</p>
			<p class="light-text">
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
			<div>
				<DropdownComponent
					dropdownValues={highLowDropdown}
					label=""
					selectedValue={selectedHighLowValue}
					id="high-low-dd"
					on:selected-dropdown={(event) =>
						handleDropDownSelections('high-low', event.detail)}
				/>
			</div>

			<div style="margin-left: 7vw;">
				<DropdownComponent
					dropdownValues={forSaleDropdown}
					label=""
					selectedValue={selectedForSaleValue}
					id="for-sale-dd"
					on:selected-dropdown={(event) =>
						handleDropDownSelections('for-sale', event.detail)}
				/>
			</div>

			<div style="margin-left: 7vw;">
				<DropdownComponent
					dropdownValues={typeDropdown}
					label=""
					selectedValue={selectedTypeValue}
					insideLabel="Type: "
					id="type-dd"
					on:selected-dropdown={(event) =>
						handleDropDownSelections('type', event.detail)}
				/>
			</div>
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
