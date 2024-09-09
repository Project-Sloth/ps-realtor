<script lang="ts">
	import FormWrapperDropdown from '@components/generic/FormWrapperDropdown.svelte'
	import SetNotSetIndicator from '@components/generic/SetNotSetIndicator.svelte'
	import { PROPERTIES } from '@store/stores'
	import { SendNUI } from '@utils/SendNUI'
	import { SHELLS, TEMP_HIDE } from '@store/stores'

	const propertyTypes = ['mlo', 'shell']
	let currentType = 'mlo'
	let existingProperties = $PROPERTIES
	let addingNewProperty = false
    let elements: {door_data: boolean}[] = [{door_data: false}];
	let description: string = ''
	let for_sale: boolean = true
	let price: number = 0
	let shell: string = Object.keys($SHELLS)[0]
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
		shell = Object.keys($SHELLS)[0]
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
	<div class="list-new-property-form">
		<div class="header">
			<div class="heading-title-wrapper">
				<i class="fas fa-circle-plus add-icon"></i>
				<p>List New Property</p>
			</div>
			<div>
				<i class="fas fa-chevron-down chevron-icon"></i>
			</div>
		</div>

		<div class="body-wrapper overflow-y-auto">
			<div class="left-column">
				<p class="title">Property Information</p>

				<p class="info">Make sure to fill everything out!</p>
			</div>
			<div class="right-column">
				<div id="property-type" class="form-row-wrapper">
					<p class="label">Property Type</p>

					<div class="action-row">
						<FormWrapperDropdown
							dropdownValues={propertyTypes}
							label=""
							id="new-listing-dd-shell-type"
                            uppercase={true}
							selectedValue={currentType}
							insideLabel="Type: "
							on:selected-dropdown={(event) =>
								(currentType = event.detail)}
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


				<div id="door-creation" class="form-row-wrapper">
					<p class="label">Door Creation <button class="regular-button" on:click={addNewElement}>+</button></p>

					{#each elements as element, index}
                        {#if currentType === 'mlo' || (currentType === 'shell' && index === 0)}
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
							
                            {#if currentType === 'mlo'}
                                {#if elements.length > 1}
							        <button on:click={() => removeElement(index)}>x</button>
						        {/if}
						    {/if}
						</div>
						{/if}
                    {/each}
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
							<FormWrapperDropdown
								dropdownValues={Object.keys($SHELLS)}
								label=""
								id="new-listing-dd-shell-type"
								selectedValue={shell}
								insideLabel="Type: "
								on:selected-dropdown={(event) =>
									(shell = event.detail)}
							/>
						</div>
					</div>
				{/if}

                <div class="w-full h-[2vh]"></div>
			</div>
		</div>

		<div class="list-new-property-form-footer">
			{#if valid}
				<button on:click={createPropertyMethod}>Create Property</button>
			{/if}
		</div>
	</div>
{/if}
