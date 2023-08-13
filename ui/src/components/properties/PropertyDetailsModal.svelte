<script lang="ts">
    import { fade } from 'svelte/transition';
    import type { IProperty } from '@typings/type';
    import { REALTOR_GRADE, SHELLS, CONFIG } from '@store/stores';
    import { SendNUI } from '@utils/SendNUI';

    export let selectedProperty: IProperty | null = null, manageProperty: boolean=false;

    function getImgArray() {
		let shellImgs = selectedProperty.extra_imgs
		const shell = selectedProperty.shell
		shellImgs = [...shellImgs, ...$SHELLS[shell].imgs]
		return shellImgs
	}
</script>

{#if selectedProperty}
    <div class="modal large-footer-modal" tabindex="-1" aria-hidden="true" transition:fade="{{duration: 100}}">
        <div class="modal-dialog large-footer-modal-dialog">
            <div class="modal-content large-footer-modal-content">
                <div class="modal-body large-footer-modal-body">
                    
                    <div class="header">
                        <div class="heading-title-wrapper">
                            <i class="fas fa-circle-info info-icon"></i>
                            <p>Property Details</p>
                        </div>
                        <div on:click={() => selectedProperty = null}>
                            <i class="fas fa-xmark close-icon"></i>
                        </div>
                    </div>

                    <div class="large-footer-modal-body-data">
                        <img src="images/apts-bg.png" alt="Apartments Background" />

                        <div class="data-details-property">
                            <div class="left-column">
                                <p class="property-name">
                                    {selectedProperty.street ? selectedProperty.street + " - " : selectedProperty.apartment ? selectedProperty.apartment + " - " : ''} {selectedProperty.property_id}
                                </p>

                                <p class="property-info">
                                    {selectedProperty.description}
                                </p>

                                <div class="gallery-image-wrapper">
                                    {#key selectedProperty.shell}
                                        {#key selectedProperty.extra_imgs}
                                            {#each getImgArray() as img}
                                                <img src={img.url} alt="Detail of the selected property" />
                                            {/each}
                                        {/key}
                                    {/key}
                                </div>
                            </div>

                            <div class="right-column">
                                <p class="title">$ {selectedProperty.price?.toLocaleString()} USD</p>

                                <button class="waypoint" on:click={() => SendNUI('setWaypoint', selectedProperty.door_data)}>
                                    <i class="fas fa-location-dot"></i>
                                    <p>Set Waypoint</p>
                                </button>

                                <div class="tiles-wrapper">
                                    {#if $REALTOR_GRADE >= 0 && selectedProperty.for_sale}
                                        <div class="each-tile">
                                            <i class="fas fa-dollar-sign"></i>
                                            For Sale
                                        </div>
                                    {/if}
                                    <div class="each-tile">
                                        <i class="fas fa-image"></i>
                                        Gallery: {$SHELLS[selectedProperty.shell] ? $SHELLS[selectedProperty.shell].imgs.length : 0}
                                    </div>

                                    <div class="each-tile">
                                        <i class="fas fa-house-chimney"></i>
                                        {selectedProperty.shell}
                                    </div>
                                    
                                    <div class="each-tile">
                                        <i class="fas fa-truck-front"></i>
                                        Garage: {selectedProperty.garage_data ? Object.keys(selectedProperty.garage_data).length > 0 ? 'Yes' : 'No' : 'No'}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    {#if $REALTOR_GRADE >= $CONFIG.manageProperty}
                        <div class="large-footer-modal-footer">
                            <button on:click={() => manageProperty = true}>Manage Property</button>
                        </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>
{/if}