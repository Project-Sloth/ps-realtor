<script lang="ts">
	import Button from '@components/generic/Button.svelte'
	import Card from '@components/generic/Card.svelte'
	import Dropdown, { type LabelValue } from '@components/generic/Dropdown.svelte'
	import FormControl from '@components/generic/FormControl.svelte'
	import Modal from '@components/generic/Modal.svelte'
	import SetNotSetIndicator from '@components/generic/SetNotSetIndicator.svelte'
	import ToggleDropdown from '@components/generic/ToggleDropdown.svelte'
	import {
		CONFIG,
		PROPERTIES,
		REALTOR_GRADE,
		SHELLS,
		TEMP_HIDE,
	} from '@store/stores'
	import type { Property } from '@typings/type'
	import { ReceiveNUI } from '@utils/ReceiveNUI'
	import { SendNUI } from '@utils/SendNUI'
	import { createEventDispatcher } from 'svelte'

	const dispatch = createEventDispatcher()

	export let manageProperty: boolean = false;
	export let selectedProperty: Property;

	const index = $PROPERTIES.findIndex(
		(property) => property.property_id === selectedProperty.property_id
	)

	let forSale: boolean = !!selectedProperty.for_sale;

	let shellTypes: LabelValue<string>[] = Object.keys($SHELLS).map(id => ({ label: $SHELLS[id].label, value: id }));

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

	function handleZonePlacement(type) {
		SendNUI('startZonePlacement', {
			type: type,
			property_id: selectedProperty.property_id,
		}).then(() => {
			$TEMP_HIDE = true
		})
	}

	let propertyImages = selectedProperty.extra_imgs,
		newImageName = '',
		newImageUrl = ''

	function addNewImage() {
		propertyImages = [
			...propertyImages,
			{
				label: newImageName,
				url: newImageUrl,
			},
		]
		newImageName = ''
		newImageUrl = ''

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
					<SetNotSetIndicator
						leftValue={selectedProperty.for_sale
							? 'Set'
							: 'Not Set'}
						rightValue={`${forSale}`}
						good={selectedProperty.for_sale}
					/>

					<ToggleDropdown
						id="dropdown_for_sale"
						onLabel="For Sale"
						offLabel="Not For Sale"
						prefix="Change: "
						value={forSale}
						flex
						changed={value => updateForSaleDropdownValue(value)}
					/>
				</FormControl>
			{/if}

			{#if $REALTOR_GRADE >= $CONFIG.sellProperty && selectedProperty.for_sale == 1}
				<FormControl label="Finalize Property Sale" controlId="input_finalize_sale">
					<SetNotSetIndicator
						leftValue={finalizedOwner?.trim() !==
						''
							? 'Set'
							: 'Not Set'}
						rightValue=""
						good={finalizedOwner?.trim() !== ''}
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
						placeholder="$1000000000"
						bind:value={propertyPrice}
						on:change={() => updatePropertyValues('UpdatePrice', { price: propertyPrice }, 'price', propertyPrice)}
					/>
				</FormControl>

				{#if selectedProperty.shell !== 'mlo'}
					<FormControl label="Manage Shell" controlId="dropdown_shell">
						<Dropdown
							id="dropdown_shell"
							items={shellTypes}
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
						<Button status="primary" click={addNewImage}>Add</Button>
					</FormControl>

					<div class="image-control-gallery">
						{#each propertyImages as image}
							<img src={image.url} alt="" />
						{/each}
					</div>
				</div>

				{#if selectedProperty.shell !== 'mlo'}
					<FormControl label="Manage Door" controlId="button_door">
						<SetNotSetIndicator
							leftValue="Door"
							rightValue={doorValueSet
								? 'Set'
								: 'Not Set'}
							good={doorValueSet}
						/>
						<div class="spacer"></div>
						<Button id="button_door" status="primary" click={() => handleZonePlacement('door')}>New Location</Button>
						<Button>Remove</Button>
					</FormControl>
				{/if}

				<FormControl label="Manage Garage" controlId="button_garage">
					<SetNotSetIndicator
						leftValue="Garage"
						rightValue={garageValueSet
							? 'Set'
							: 'Not Set'}
						good={garageValueSet}
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
		grid-template-columns: repeat(auto-fill, minmax(6rem, 1fr));
		gap: .5rem;
	}

	.image-control-gallery > img {
		border-radius: 6px;
	}
</style>