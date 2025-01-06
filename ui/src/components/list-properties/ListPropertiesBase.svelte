<script lang="ts">
	import Button from '@components/generic/Button.svelte'
	import Card from '@components/generic/Card.svelte'
	import Dropdown, { type LabelValue } from '@components/generic/Dropdown.svelte'
	import FormControl from '@components/generic/FormControl.svelte'
	import SetIndicator from '@components/generic/SetIndicator.svelte'
	import { PROPERTIES, SHELL_TYPES, SHELLS, TEMP_HIDE } from '@store/stores'
	import type { Zone } from '@typings/type'
	import { SendNUI } from '@utils/SendNUI'

	const propertyTypes = [
		{ label: 'MLO', value: 'mlo' }, 
		{ label: 'Shell', value: 'shell' }
	];
	
	let currentType = propertyTypes[0].value;

	let existingProperties = $PROPERTIES
	let addingNewProperty = false;
    let elements: {door_data: boolean}[] = [{door_data: false}];
	let description: string = ''
	let for_sale: boolean = true
	let price: number = 0
	let shell: string = $SHELL_TYPES[0]?.value;
	let garage_data: boolean = false
	let garden_data: boolean = false
	let zone_data: boolean = false
	let valid: boolean = false
	

	function createZone(type: Zone, index?: number) {
        const data = { type: type, propertyType: currentType }

        SendNUI('create:createZone', data).then((success: boolean) => {
            if (!success) return

            if (type === 'door') elements[index].door_data = true
            else if (type === 'zone') zone_data = true
            else if (type === 'garden') garden_data = true
            else garage_data = true
        })

		$TEMP_HIDE = true
	}

	function removeGarage() {
		SendNUI('create:removeGarage').then(()=> {
			garage_data = false
		})
	}

	function removeGarden() {
		SendNUI('create:removeGarden').then(()=> {
			garden_data = false
		})
	}

    function addNewElement() {
		elements = [...elements, {door_data: null}];
	}

	function removeElement(index: number) {
		SendNUI('create:removeDoor', index)
		elements.splice(index, 1);
		elements = [...elements];
	}

	function createPropertyMethod() {
		SendNUI('create:confirmListing')
		addingNewProperty = false

		description = ''
		for_sale = true
		price = 0
		zone_data = false
		shell = $SHELL_TYPES[0].value
		garage_data = false
		garden_data = false
        elements = [{door_data: false}];
	}

	$: {
		valid =
			description.length > 0 && price > 0 && (currentType === 'mlo' || currentType === 'shell' && shell.length > 0) && elements.every(element => element.door_data !== false)
		SendNUI('create:setTextFields', {
			description: description,
			for_sale: for_sale,
			price: price,
			shell: shell,
		})
	}
</script>

{#if existingProperties.length <= 0 && !addingNewProperty}
	<div class="first-property-container">
		<img src="images/house.webp" alt="House Icon" />

		<p>You haven't listed a property yet!</p>

		<Button status="primary" click={() => addingNewProperty = !addingNewProperty}>
			Add New Property
		</Button>
	</div>
{:else}
	<div class="new-property-container">
		<Card title="New Property Listing">
			<i class="fas fa-circle-plus" style="color: var(--blue-color);" slot="icon"></i>

			<section class="new-property-subtitle">
				<h2>Property Information</h2>
				<small>Make sure to fill everything out!</small>
			</section>

			<section class="new-property-controls">
				<FormControl label="Type" controlId="dropdown_property_type">
					<Dropdown
						id="dropdown_property_type"
						items={propertyTypes}
						bind:value={currentType}
						prefix="Type:"
						flex
					/>
				</FormControl>

				{#if currentType === 'mlo'}
					<FormControl label="Zone" controlId="button_property_zone">
						<SetIndicator
							prefix="Zone"
							value={zone_data ? 'Set' : 'Not Set'}
							valid={!!zone_data}
						/>
						<div class="spacer"></div>
						<Button 
							id="button_property_zone" 
							status="primary" 
							click={() => createZone('zone')}>
							{zone_data ? 'Change Zone' : 'Set Zone'}
						</Button>
					</FormControl>				
				{:else if currentType === 'shell'}
					<FormControl label="Shell" controlId="dropdown_property_shell">
						<Dropdown
							id="dropdown_property_shell"
							items={$SHELL_TYPES}
							bind:value={shell}
							prefix="Type: "
							flex
						/>
					</FormControl>
				{/if}

				<FormControl label="Price" controlId="input_property_price">
					<input
						id="input_property_price"
						type="number"
						class="flex-auto"
						placeholder="1000000000"
						bind:value={price}
					/>
				</FormControl>

				<FormControl label="Description" controlId="textarea_property_description">
					<textarea
						id="textarea_property_description"
						class="flex-auto"
						rows="5"
						placeholder="Write a short and sweet description about the property..."
						bind:value={description}
					/>
				</FormControl>


				{#if currentType === 'mlo'}
					<div class="new-property-door-list">
						<div class="new-property-door-list-header">
							<span style="font-weight: 500; font-size: 0.875rem; line-height: 1.25rem;">Doors</span>
							<div class="spacer"></div>
							<Button status="primary" click={addNewElement} icon="fa-plus" ariaLabel="Add door"></Button>
						</div>
	
						<div class="new-property-door-list-body">
							{#each elements as element, index}
								<FormControl>
									<SetIndicator
										prefix="Door"
										value={element.door_data ? 'Set' : 'Not Set'}
										valid={!!element.door_data}
									/>
									<div class="spacer"></div>
									<Button status="primary" click={() => createZone('door', index)}>
										{element.door_data ? 'Change Door' : 'Set Door'}
									</Button>
	
									<Button status="danger" icon="fa-trash" click={() => removeElement(index)} ariaLabel="Delete door"></Button>
								</FormControl>
							{/each}
						</div>
					</div>
					{:else if currentType === 'shell'}
					<FormControl label="Door" controlId="dropdown_property_shell">
						<SetIndicator
							prefix="Door"
							value={elements[0].door_data ? 'Set' : 'Not Set'}
							valid={!!elements[0].door_data}
						/>
						<div class="spacer"></div>
						<Button status="primary" click={() => createZone('door', 0)}>
							{elements[0].door_data ? 'Change Door' : 'Set Door'}
						</Button>
					</FormControl>
				{/if}
			</section>

			<div class="new-property-subtitle">
				<h3>Property Additions</h3>
				<small>The fields below are optional!</small>
			</div>

			<section class="new-property-controls">
				<FormControl label="Garage" controlId="button_property_garage">
					<SetIndicator
						prefix="Garage"
						value={garage_data ? 'Set' : 'Not Set'}
						valid={!!garage_data}
					/>
					<div class="spacer"></div>
					<Button 
						id="button_property_garage" 
						status="primary"
						click={() => garage_data ? removeGarage() : createZone('garage')}>
						{garage_data ? 'Remove Garage' : 'Set Garage'}
					</Button>
				</FormControl>

				{#if currentType !== 'mlo'}
					<FormControl label="Garden" controlId="button_property_garden">
							<SetIndicator
								prefix="Garden"
								value={garden_data ? 'Set' : 'Not Set'}
								valid={!!garden_data}
							/>
							<div class="spacer"></div>
							<Button
								id="button_property_garden"
								status="primary"
								click={() => garden_data ? removeGarden() : createZone('garden')}>
								{garden_data ? 'Remove Garden' : 'Set Garden'}
							</Button>
					</FormControl>
				{/if}
			</section>

			<section class="new-property-actions" slot="footer">
				<div class="spacer"></div>
				<Button click={createPropertyMethod} disabled={!valid}>Create Property</Button>
			</section>
		</Card>
	</div>
{/if}

<style>
	.first-property-container {
		display: flex;
		flex-direction: column;
		place-items: center;
		place-content: center;
		height: 100%;
		gap: .5rem;
	}

	.first-property-container > img {
		height: 4.5rem;
		width: 5rem;
	}

	.new-property-container {
		display: flex;
		flex-direction: column;
		gap: 1rem;
		
		height: 100%;
	}

	.new-property-subtitle {
		padding-bottom: 0.25rem;
		border-bottom: 0.1px solid var(--light-border-color);
	}

	.new-property-subtitle > small {
		color: var(--light-border-color-6);
	}

	.new-property-controls {
		flex: 1;

		display: flex;
		flex-direction: column;
		gap: 1rem;

		margin-left: auto;
		margin-right: auto;

		width: 100%;
		max-width: 30rem;
	}
	
	.new-property-door-list {
		display: flex; 
		flex-direction: column;
	}

	.new-property-door-list-header {
		display: flex; 
		place-items: center; 
		padding: 1rem; 
		border: 1px solid var(--light-border-color-2); 
		border-bottom: none; 
		border-radius: 3px 3px 0 0;
	}

	.new-property-door-list-body {
		display: flex; 
		flex-direction: column; 
		gap: 1rem; 
		padding: 1rem; 
		border: 1px solid var(--light-border-color-2); 
		border-radius: 0 0 3px 3px;
	}

	.new-property-actions {
		display: flex;
		flex-direction: row;
		gap: 0.5rem;
	}
</style>