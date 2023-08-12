<script lang="ts">
	import FormWrapperDropdown from "@components/generic/FormWrapperDropdown.svelte"
    import SetNotSetIndicator from "@components/generic/SetNotSetIndicator.svelte"
    import { PROPERTIES } from '@store/stores'
    import { ReceiveNUI } from '@utils/ReceiveNUI'
	import { SendNUI } from '@utils/SendNUI'
	import { SHELLS, TEMP_HIDE } from '@store/stores'
    import { fly } from 'svelte/transition';

    let existingProperties = $PROPERTIES;
    let addingNewProperty = false;

    let description: string = '';
	let for_sale: boolean = true;
	let price: number = 0;
	let shell: string = Object.keys($SHELLS)[0];
	let door_data: any = null;
	let garage_data: any = null;

    let valid: boolean = false;

    ReceiveNUI('createdDoor', (data) => {
		door_data = data
	});

	ReceiveNUI('createdGarage', (data) => {
		garage_data = data
	});

    function createZone(type) {
        SendNUI('create:createZone', { type: type })
        $TEMP_HIDE = true
    }

    function removeGarage() {
        SendNUI('create:removeGarage', {});
    }

    function createPropertyMethod() {
        SendNUI("create:confirmListing");
        addingNewProperty = false;

        description = '';
        for_sale = true;
        price = 0;
        shell = Object.keys($SHELLS)[0];
        door_data = null;
        garage_data = null;
    }

    $: {
        valid = description.length > 0 && price > 0 && shell.length > 0 && door_data
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

        <button on:click={() => addingNewProperty = !addingNewProperty}>
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

        <div class="body-wrapper">
            <div class="left-column">
                <p class="title">Property Information</p>

                <p class="info">Make sure to fill everything out!</p>
            </div>
            <div class="right-column">
                <div id="door-creation" class="form-row-wrapper">
                    <p class="label">Door Creation</p>
                
                    <div class="action-row">
                        <SetNotSetIndicator leftValue="Door" rightValue={door_data ? "Set" : "Not Set"} good={door_data} />
                        <button class="regular-button" on:click={() => createZone('door')}>{door_data ? 'Unset' : 'Set'}</button>
                    </div>
                </div>

                <div id="garage-creation" class="form-row-wrapper">
                    <p class="label">Garage Creation</p>
                
                    <div class="action-row">
                        <SetNotSetIndicator leftValue="Garage" rightValue={garage_data ? "Set" : "Not Set"} good={garage_data} />
                        <button class="regular-button" on:click={() => garage_data ? removeGarage() : createZone('garage')}>{garage_data ? 'Remove Garage' : 'Set Garage'}</button>
                    </div>
                </div>

                <div id="description" class="form-row-wrapper">
                    <p class="label">Description</p>
                
                    <div class="action-row">
                        <textarea rows="5" placeholder="Write a short and sweet description about the property..." bind:value={description} />
                    </div>
                </div>

                <div id="price" class="form-row-wrapper">
                    <p class="label">Price</p>
                
                    <div class="action-row">
                        <input type="number" placeholder="$1000000000" bind:value={price} />
                    </div>
                </div>

                <div id="shell-type" class="form-row-wrapper">
                    <p class="label">Shell Type</p>
                
                    <div class="action-row">
                        <FormWrapperDropdown dropdownValues={Object.keys($SHELLS)} label="" id="new-listing-dd-shell-type" selectedValue={shell} insideLabel="Type: " on:selected-dropdown={(event) => shell = event.detail} />
                    </div>
                </div>
            </div>
        </div>

        <div class="list-new-property-form-footer">
            {#if valid}
                <button on:click={createPropertyMethod}>Create Property</button>
            {/if}
        </div>
    </div>
{/if}
