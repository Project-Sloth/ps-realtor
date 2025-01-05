<script lang="ts">
	import Button from '@components/generic/Button.svelte'
	import Card from '@components/generic/Card.svelte'
	import Dropdown from '@components/generic/Dropdown.svelte'
	import FormControl from '@components/generic/FormControl.svelte'
	import Modal from '@components/generic/Modal.svelte'
	import SetIndicator from '@components/generic/SetIndicator.svelte'
	import ToggleDropdown from '@components/generic/ToggleDropdown.svelte'
	import {
		CONFIG,
		PROPERTIES,
		REALTOR_GRADE,
		SHELL_TYPES,
		TEMP_HIDE
	} from '@store/stores'
	import type { Property, PropertyImage, Zone } from '@typings/type'
	import { ReceiveNUI } from '@utils/ReceiveNUI'
	import { SendNUI } from '@utils/SendNUI'
	import { createEventDispatcher } from 'svelte'
	import PropertyImageCard from './PropertyImageCard.svelte'

	const dispatch = createEventDispatcher()

	export let manageProperty: boolean = false;
	export let selectedProperty: Property;

	const index = $PROPERTIES.findIndex(
		(property) => property.property_id === selectedProperty.property_id
	)

	let forSale: boolean = !!selectedProperty.for_sale;

	function updateForSaleDropdownValue(value: boolean) {
		SendNUI('updatePropertyData', {
			type: 'UpdateForSale',
			property_id: selectedProperty.property_id,
			data: { forsale: value },
		})

		$PROPERTIES[index].for_sale = value ? 1 : 0;
		selectedProperty.for_sale = value ? 1 : 0;
	}

	let finalizedOwner = selectedProperty.owner ? selectedProperty.owner : ''

	let description = selectedProperty.description ?? ''

	let propertyPrice = selectedProperty.price

	let newShell = selectedProperty.shell

	function updatePropertyValues<K extends keyof Property>(type: string, data: object, key: K, value: Property[K]) {
		SendNUI('updatePropertyData', { type, data, property_id: selectedProperty.property_id })
		$PROPERTIES[index][key] = value
		selectedProperty[key] = value
	}

	let doorValueSet = selectedProperty.door_data.length > 0 ? true : false
	let garageValueSet = selectedProperty.garage_data
		? selectedProperty.garage_data.x
			? true
			: false
		: false

	function handleZonePlacement(type: Zone) {
		SendNUI('startZonePlacement', {
			type: type,
			property_id: selectedProperty.property_id,
		}).then(() => {
			$TEMP_HIDE = true
		})
	}

	let propertyImages = selectedProperty.extra_imgs;
	let newImageName = '';
	let newImageUrl = '';

	function addImage() {
		propertyImages = [
			...propertyImages,
			{
				label: newImageName,
				url: newImageUrl,
			},
		]
		newImageName = ''
		newImageUrl = ''

		saveImages();
	}

	function removeImage(image: PropertyImage) {
		propertyImages = propertyImages.filter(i => i !== image);
		saveImages();
	}

	function swapImage(fromIdx: number, toIdx: number) {
		[ propertyImages[fromIdx], propertyImages[toIdx] ] = [ propertyImages[toIdx], propertyImages[fromIdx] ];
		saveImages();
	}

	function saveImages() {
		updatePropertyValues(
			'UpdateImgs',
			{ imgs: propertyImages },
			'extra_imgs',
			propertyImages
		)
	}

	function deleteProperty() {
		dispatch('delete-property', selectedProperty)
	}

	ReceiveNUI('garageMade', () => {
		garageValueSet = true
	})
</script>

<Modal bind:open={manageProperty}>
	<Card title="Manage Property">
		<i class="fas fa-pen info-icon" slot="icon" style="color: var(--blue-color);" />

		<button slot="header-action" on:click={() => manageProperty = false}>
			<i class="fas fa-xmark close-icon"></i>
		</button>

		<section class="property-management-subtitle">
			<h2>Change Property Settings</h2>
			<small>Changes are applied in real-time!</small>
		</section>

		<section class="property-management-controls">
			{#if $REALTOR_GRADE >= $CONFIG.changePropertyForSale}
				<FormControl label="Sell Property" controlId="dropdown_for_sale">
					<SetIndicator
						prefix="For sale"
						value={forSale ? 'Set' : 'Not Set'}
						valid={forSale}
					/>

					<ToggleDropdown
						id="dropdown_for_sale"
						onLabel="For Sale"
						offLabel="Not For Sale"
						prefix="Availability:"
						bind:value={forSale}
						flex
						changed={value => updateForSaleDropdownValue(value)}
					/>
				</FormControl>
			{/if}

			{#if $REALTOR_GRADE >= $CONFIG.sellProperty && selectedProperty.for_sale == 1}
				<FormControl label="Finalize Property Sale" controlId="input_finalize_sale">
					<SetIndicator
						prefix="Owner"
						value={finalizedOwner?.trim() !== '' ? 'Set' : 'Not Set'}
						valid={finalizedOwner?.trim() !== ''}
					/>

					<input
						id="input_finalize_sale"
						type="text"
						class="flex-auto"
						placeholder="ID: 34343434343"
						bind:value={finalizedOwner}
					/>

					<Button status="primary" click={() => updatePropertyValues('UpdateOwner', { targetSrc: finalizedOwner }, 'owner', finalizedOwner )}>
						Request
					</Button>

				</FormControl>
			{/if}

			{#if $REALTOR_GRADE >= $CONFIG.manageProperty}
				<FormControl label="Manage Description" controlId="textarea_description">
					<textarea
						id="textarea_description"
						class="flex-auto"
						rows="5"
						placeholder="Write a short and sweet description about the property..."
						bind:value={description}
						on:change={() => updatePropertyValues('UpdateDescription', { description: description }, 'description', description)}
					/>
				</FormControl>

				<FormControl label="Manage Price" controlId="input_price">
					<input						
						id="input_price"
						type="number"
						class="flex-auto"
						placeholder="1000000000"
						bind:value={propertyPrice}
						on:change={() => updatePropertyValues('UpdatePrice', { price: propertyPrice }, 'price', propertyPrice)}
					/>
				</FormControl>

				{#if selectedProperty.shell !== 'mlo'}
					<FormControl label="Manage Shell" controlId="dropdown_shell">
						<Dropdown
							id="dropdown_shell"
							items={$SHELL_TYPES}
							bind:value={newShell}
							prefix="Type: "
							flex
							changed={shell => updatePropertyValues('UpdateShell', { shell }, 'shell', shell)}
						/>
					</FormControl>
				{/if}
				
				<div class="image-control-container">				
					<FormControl label="Add Images" controlId="img-name">
						<input
							id="img-name"
							type="text"
							class="flex-auto"
							placeholder="Name"
							bind:value={newImageName}
						/>
						<input
							id="img-url"
							type="text"
							class="flex-auto"
							placeholder="URL"
							bind:value={newImageUrl}
						/>
						<Button status="primary" click={addImage}>Add</Button>
					</FormControl>
					<div class="image-control-gallery">
						{#each propertyImages as image, idx (image.url)}
							<PropertyImageCard {...image}>
								<svelte:fragment>
									<Button status="primary" icon="fa-arrow-left" ariaLabel="Shift left" click={() => swapImage(idx, idx == 0 ? propertyImages.length : idx - 1)}></Button>
									<Button status="danger" icon="fa-trash" ariaLabel="Delete image" click={() => removeImage(image)}></Button>
									<Button status="primary" icon="fa-arrow-right" ariaLabel="Shift right" click={() => swapImage(idx, idx == propertyImages.length - 1 ? 0 : idx + 1)}></Button>
								</svelte:fragment>
							</PropertyImageCard>
						{/each}
					</div>
				</div>

				{#if selectedProperty.shell !== 'mlo'}
					<FormControl label="Manage Door" controlId="button_door">
						<SetIndicator
							prefix="Door"
							value={doorValueSet ? 'Set': 'Not Set'}
							valid={doorValueSet}
						/>
						<div class="spacer"></div>
						<Button id="button_door" status="primary" click={() => handleZonePlacement('door')}>New Location</Button>
						<Button>Remove</Button>
					</FormControl>
				{/if}

				<FormControl label="Manage Garage" controlId="button_garage">
					<SetIndicator
						prefix="Garage"
						value={garageValueSet ? 'Set' : 'Not Set'}
						valid={garageValueSet}
					/>
					<div class="spacer"></div>
					<Button id="button_garage" status="primary" click={() => handleZonePlacement('garage')}>New Location</Button>
					<Button click={() => updatePropertyValues('UpdateGarage', {}, 'garage_data', null)}>Remove</Button>
				</FormControl>
			{/if}
		</section>

		<div slot="footer">
			{#if $REALTOR_GRADE >= $CONFIG.deleteProperty}
				<Button status="danger" click={deleteProperty}>Delete Property</Button>
			{/if}
		</div>

	</Card>
</Modal>

<style>
	.property-management-subtitle {
		padding-bottom: 0.25rem;
		border-bottom: 0.1px solid var(--light-border-color);
	}

	.property-management-subtitle > small {
		color: var(--light-border-color-6);
	}

	.property-management-controls {
		display: flex;
		flex-direction: column;
		gap: 1rem;

		margin-left: auto;
		margin-right: auto;
		width: 100%;
		max-width: 30rem;
	}

	.image-control-container {
		display: flex;
		flex-direction: column; 
		gap: 1rem;
	}

	.image-control-gallery {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(9rem, 1fr));
		grid-auto-rows: min-content;
		gap: .5rem;
		--property-image-card-height: 5rem;
	}
</style>