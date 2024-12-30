<script lang="ts">
    import { fade } from 'svelte/transition';
    import type { Property } from '@typings/type';
    import { REALTOR_GRADE, SHELLS, CONFIG } from '@store/stores';
    import { SendNUI } from '@utils/SendNUI';
	import Card from '@components/generic/Card.svelte'
	import Tile from '@components/generic/Tile.svelte'
	import Modal from '@components/generic/Modal.svelte'
	import Button from '@components/generic/Button.svelte'

    export let selectedProperty: Property | null = null, manageProperty: boolean=false;

    function getImgArray() {
		let shellImgs = selectedProperty.extra_imgs
		const shell = selectedProperty.shell
		shellImgs = [...shellImgs, ...$SHELLS[shell].imgs]
		return shellImgs
	}
</script>

<style>
    .property-container {
        --card-body-direction: column;
    }

    .property-container > :global(.card) {
        position: absolute;

        z-index: 1;

        width: 60%;
        max-height: 90%;

        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
    }

    :global(.card-body) > img {
        max-height: 10rem;
        object-fit: cover;
        border-radius: 12px;
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

    .property-info {
        display: flex;
        flex-direction: column;
    }

    .property-info > p {
        text-align: justify;
        color: var(--light-border-color-8);
    }



    /* .property-description {
        width: 75%;
        font-weight: 500;
        color: var(--light-border-color-8);
    } */

    .property-gallery {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(12rem, 1fr));
        gap: .5rem;
    }

    .property-gallery > img {
        text-align: center;
        border-radius: 12px;
    }
</style>

{#if selectedProperty}
    <Modal>
        <Card title="Property details">
            <i class="fas fa-circle-info" slot="icon" style="color: var(--blue-color);"></i>

            <button slot="header-action" on:click={() => selectedProperty = null}>
                <i class="fas fa-xmark close-icon"></i>
            </button>

            <img src="images/apts-bg.png" alt="Apartments Background" />

            <section class="property-info">
                <h2>
                    {selectedProperty.street ? selectedProperty.street + " - " : selectedProperty.apartment ? selectedProperty.apartment + " - " : ''} {selectedProperty.property_id} Zancudo Ave
                </h2>
                <p>
                    <!-- {selectedProperty.description} -->Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centurie
                </p>
            </section>

            <h3>Features</h3>

            <div style="display: flex; flex-direction: row; gap: 1rem; align-items: baseline;">
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

                    <Button status="primary" icon="fa-location-dot" block click={() => SendNUI('setWaypoint', selectedProperty.door_data)}>Set Waypoint</Button>
                </section>
            </div>

            
            <h3>Gallery</h3>
            <section class="property-gallery">
                {#key selectedProperty.shell}
                    {#key selectedProperty.extra_imgs}
                        {#each getImgArray() as img}
                            <img src={img.url} alt="Detail of the selected property" />
                        {/each}
                    {/key}
                {/key}
            </section>

            <!-- {#if $REALTOR_GRADE >= $CONFIG.manageProperty}{/if} -->
            <Button slot="footer" click={() => manageProperty = true}>Manage Property</Button>
        </Card>
    </Modal>
{/if}