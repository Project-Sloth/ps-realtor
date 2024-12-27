<script lang="ts">
	import SetNotSetIndicator from '@components/generic/SetNotSetIndicator.svelte'
	import { PROPERTIES } from '@store/stores'
	import { SendNUI } from '@utils/SendNUI'
	import { SHELLS, TEMP_HIDE } from '@store/stores'
	import Dropdown, { type LabelValue } from '@components/generic/Dropdown.svelte'
	import Card from '@components/generic/Card.svelte'

	const propertyTypes = [
		{ label: 'MLO', value: 'mlo' }, 
		{ label: 'Shell', value: 'shell' }
	];
	let currentType = propertyTypes[0].value;
	let shellTypes: LabelValue<string>[] = Object.keys($SHELLS).map(id => ({ label: $SHELLS[id].label, value: id }));

	let existingProperties = $PROPERTIES
	let addingNewProperty = true;
    let elements: {door_data: boolean}[] = [{door_data: false}];
	let description: string = ''
	let for_sale: boolean = true
	let price: number = 0
	let shell: string = shellTypes[0]?.value;
	let garage_data: boolean = false
	let garden_data: boolean = false
	let zone_data: boolean = false
	let valid: boolean = false
	

	function createZone (type: 'door' | 'garage' | 'zone' | 'garden', index?: number) {
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
		shell = shellTypes[0].value
		garage_data = false
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
	<div class="no-new-properties-base">
		<img src="images/House.png" alt="House Icon" />

		<p>You haven't listed a property yet!</p>

		<button on:click={() => (addingNewProperty = !addingNewProperty)}>
			Add New Property
		</button>
	</div>
{:else}
	<Card title="List New Property">
		<i class="fas fa-circle-plus" slot="icon"></i>
		
		<div class="left-column">
			<p class="title">Property Information</p>

			<p class="info">Make sure to fill everything out!</p>
		</div>

		<div class="right-column">
			<div id="property-type" class="form-row-wrapper">
				<p class="label">Property Type</p>

				<div class="action-row">
					<Dropdown 
						items={propertyTypes}
						bind:value={currentType}
						prefix="Type:"
					/>
				</div>
			</div>

			{#if currentType === 'mlo'}
			<div id="zone-creation" class="form-row-wrapper">
				<p class="label">Zone Type</p>
				<div class="action-row">
					<SetNotSetIndicator
						leftValue="Zone"
						rightValue={zone_data ? 'Set' : 'Not Set'}
						good={zone_data}
					/>
					<button
						class="regular-button"
						on:click={() => createZone('zone')}
						>{zone_data ? 'Unset' : 'Set'}</button
					>
				</div>
			</div>
			{/if}


			<div id="door-creation" class="form-row-wrapper door-creation-container">					
				{#if currentType === 'mlo'}
					<div class="label flex door-creation-title">
						<span>Door Creation</span>
						<div class="spacer"></div>
						<button class="regular-button" on:click={addNewElement}><i class="fas fa-plus"></i></button>
					</div>

					{#each elements as element, index}
						<div class="action-row" style="margin-bottom: 10px;">
							<SetNotSetIndicator
								leftValue="Door"
								rightValue={element.door_data ? 'Set' : 'Not Set'}
								good={element.door_data}
							/>
							<button
								class="regular-button"
								on:click={() => createZone('door', index)}
								>{element.door_data ? 'Unset' : 'Set'}</button
							>							

							<button class="door-remove-btn" on:click={() => removeElement(index)}><i class="fas fa-close"></i></button>
						</div>
					{/each}
				
				{:else if currentType === 'shell'}
					<p class="label">Door Creation</p>

					<div class="action-row" style="margin-bottom: 10px;">
						<SetNotSetIndicator
							leftValue="Door"
							rightValue={elements[0].door_data ? 'Set' : 'Not Set'}
							good={elements[0].door_data}
						/>
						<button
							class="regular-button"
							on:click={() => createZone('door', 0)}
							>{elements[0].door_data ? 'Unset' : 'Set'}</button
						>
					</div>
				{/if}

			</div>

			<div id="garage-creation" class="form-row-wrapper">
				<p class="label">Garage Creation</p>

				<div class="action-row">
					<SetNotSetIndicator
						leftValue="Garage"
						rightValue={garage_data ? 'Set' : 'Not Set'}
						good={garage_data}
					/>
					<button
						class="regular-button"
						on:click={() =>
							garage_data
								? removeGarage()
								: createZone('garage')}
						>{garage_data
							? 'Remove Garage'
							: 'Set Garage'}</button
					>
				</div>
			</div>

			{#if currentType !== 'mlo'}
			<div id="garden-creation" class="form-row-wrapper">
				<p class="label">Garden Creation</p>

				<div class="action-row">
					<SetNotSetIndicator
						leftValue="Garden"
						rightValue={garden_data ? 'Set' : 'Not Set'}
						good={garden_data}
					/>
					<button
						class="regular-button"
						on:click={() =>
							garden_data
								? removeGarden()
								: createZone('garden')}
						>{garden_data
							? 'Remove Garden'
							: 'Set Garden'}</button
					>
				</div>
			</div>
			{/if}


			<div id="description" class="form-row-wrapper">
				<p class="label">Description</p>

				<div class="action-row">
					<textarea
						rows="5"
						placeholder="Write a short and sweet description about the property..."
						bind:value={description}
					/>
				</div>
			</div>

			<div id="price" class="form-row-wrapper">
				<p class="label">Price</p>

				<div class="action-row">
					<input
						type="number"
						placeholder="$1000000000"
						bind:value={price}
					/>
				</div>
			</div>

			

			{#if currentType === 'shell'}
				<div id="shell-type" class="form-row-wrapper">
					<p class="label">Shell Type</p>

					<div class="action-row">
						<Dropdown
							items={shellTypes}
							bind:value={shell}
							prefix="Type: "
						/>
					</div>
				</div>
			{/if}

			<div class="w-full h-[2vh]"></div>
		</div>

		<button class="btn" on:click={createPropertyMethod} disabled={!valid} slot="footer">Create Property</button>		
	</Card>
{/if}

<style>
	:global(.card-header) > i {
		color: var(--blue-color);
	}

	:global(.card-body) {
		flex-direction: row;
		gap: 2rem;
	}

	.left-column {
		position: sticky;
		top: 0;
		display: flex;
		flex-direction: column;
		height: min-content;
  	}

	.left-column > .title {
		font-weight: 600;
	}

	.left-column > .info {
		font-weight: 400;
		color: var(--white-color);
		margin-top: 0.3vw;
	}

	.btn {
		border-radius: 0.1vw;

		width: fit-content;

		font-weight: 500;

		padding: 0.15vw 0.5vw;
		text-align: center;
		vertical-align: middle;

		background: var(--light-border-color);
		border: 1px solid var(--light-border-color-2);
  	}

	.btn:disabled {
		color: rgba(255, 255, 255, 0.3);
	}

	.btn:hover:not(:disabled) {
		color: rgba(255, 255, 255, 0.3);
		border: 1px solid var(--light-border-color-6);
	}
</style>