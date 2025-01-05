<script lang="ts">
    import Button from '@components/generic/Button.svelte'
    import Card from '@components/generic/Card.svelte'
    import Modal from '@components/generic/Modal.svelte'
    import Tile from '@components/generic/Tile.svelte'
    import { APARTMENTS, REALTOR_GRADE, SHELLS } from '@store/stores'
    import type { Property } from '@typings/type'
    import { SendNUI } from '@utils/SendNUI'
    import PropertyImageCard from './PropertyImageCard.svelte'

    export let selectedProperty: Property;
    export let manageProperty: boolean = false;
    export let closed: () => void;

    function getImgArray() {
		let shellImgs = selectedProperty.extra_imgs
		const shell = selectedProperty.shell
		shellImgs = [...shellImgs, ...$SHELLS[shell].imgs]
		return shellImgs
	}

    function setWaypoint(property: Property) {
        if (!property.apartment) {
            SendNUI('setWaypoint', property.door_data);
            return;
        }
            
        const aptDoor = $APARTMENTS.find(i => i.apartmentData.label == property.apartment)?.apartmentData.door;

        if (aptDoor) {
            SendNUI('setWaypoint', aptDoor);
            return;
        }

        console.error('Unable to set waypoint, unable to find door coordinates');
    }
</script>

{#if selectedProperty}
    <Modal open={!!selectedProperty} closed={closed}>
        <Card title="Property details">
            <i class="fas fa-circle-info" slot="icon" style="color: var(--blue-color);"></i>

            <button slot="header-action" on:click={closed}>
                <i class="fas fa-xmark close-icon"></i>
            </button>

            <img class="property-banner" src="images/property-banner.webp" alt="Property Banner" />

            <section class="property-info">
                <h2>{selectedProperty.street ? selectedProperty.street + " - " : selectedProperty.apartment ? selectedProperty.apartment + " - " : ''} {selectedProperty.property_id}</h2>
                <p>{selectedProperty.description}</p>
            </section>

            <h3>Features</h3>

            <div class="property-features-actions-container">
                <section class="property-features">   
                    {#if $REALTOR_GRADE >= 0 && selectedProperty.for_sale}
                        <Tile icon="fa-sign-hanging" border>
                            For Sale
                        </Tile>
                    {/if}
    
                    <!-- <Tile icon="fa-image" border>Gallery: {$SHELLS[selectedProperty.shell] ? $SHELLS[selectedProperty.shell].imgs.length : 0}</Tile> -->
    
                    <Tile icon="fa-house-chimney" border>{selectedProperty.shell}</Tile>
    
                    {#if selectedProperty.garage_data && Object.keys(selectedProperty.garage_data).length > 0}
                        <Tile icon="fa-truck-front" border>Garage</Tile>
                    {/if}
                </section>
    
                <section class="property-actions">
                    <Tile icon="fa-landmark">
                        ${selectedProperty.price?.toLocaleString()}
                    </Tile>

                    <Button status="primary" icon="fa-location-dot" block click={() => setWaypoint(selectedProperty)}>Set Waypoint</Button>
                </section>
            </div>

            
            <h3>Gallery</h3>
            <section class="property-gallery">
                {#key selectedProperty.shell}
                    {#key selectedProperty.extra_imgs}
                        {#each getImgArray() as image}
                            <PropertyImageCard {...image}></PropertyImageCard>
                        {/each}
                    {/key}
                {/key}
            </section>

            <!-- {#if $REALTOR_GRADE >= $CONFIG.manageProperty}{/if} -->
            <svelte:fragment slot="footer">
                {#if !selectedProperty.apartment}
                    <Button  click={() => manageProperty = true}>Manage Property</Button>
                {/if}
            </svelte:fragment>
        </Card>
    </Modal>
{/if}

<style>
    .property-banner {
        max-height: 10rem;
        object-fit: cover;
        border-radius: 12px;
        object-position: 0 40%;
    }

    .property-info {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .property-info > h2 {
		padding-bottom: 0.25rem;
		border-bottom: 0.1px solid var(--light-border-color);
    }

    .property-info > p {
        text-align: justify;
        color: var(--light-border-color-8);
    }

    .property-features-actions-container {
        display: flex;
        flex-direction: row;
        gap: 1rem;
    }

    .property-features {
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
        gap: 0.5rem;

        --tile-color: #313131;
        --tile-icon-color: var(--light-border-color-6);
        flex: 1;
    }

    .property-actions {
        flex: 30% 0 0;  
        display: flex;
        flex-direction: column;    
        gap: 0.5rem;  
    }

    .property-actions > :global(.tile) {
        --tile-color: #313131;
        --tile-icon-color: var(--light-border-color-6);
        width: 100%;
        justify-content: center;
    }

    .property-gallery {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr));
        grid-auto-rows: 12rem;
        gap: .5rem;
        --property-image-card-height: 11rem;
    }
</style>