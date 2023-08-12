<script lang="ts">
	import { PROPERTIES } from '@store/stores'
    import type { IApartment } from '@typings/type'
	import { SendNUI } from '@utils/SendNUI'
	import { onMount } from 'svelte'
    import { fade } from 'svelte/transition';

    export let selectedApartment: IApartment | null = null;

    let tenants: string[] = [], tenantsResult: string[] = [];
    let searchTerm: string = "";
    let tempSrc: string = null;

    onMount(()=>{
        const  apartmentName: string = selectedApartment.apartmentData.label as string
        
        // search PROPERTIES for all the properties that have the same apartment name and return the owner
        const arrCitizenids = $PROPERTIES.filter((property) => property.apartment === apartmentName).map((property) => property.owner)
        if (arrCitizenids.length === 0 || arrCitizenids[0] === undefined) {
            tenantsResult = []
            return
        }

        SendNUI('getNames', arrCitizenids).then((names: string[]) => {
            tenants = names
        })
    });

    function addNewTenant() {
        SendNUI('addTenantToApartment', {
            apartment: selectedApartment.apartmentData.label, 
            targetSrc: tempSrc
        });
        
        selectedApartment = null;
    }

    $: {
        if (searchTerm.length > 0) {
            tenantsResult = tenants.filter((tenant) => tenant.toLowerCase().includes(searchTerm.toLowerCase())) || []
        } else {
            tenantsResult = tenants || [];
        }
    }
</script>

{#if selectedApartment !== null}
    <div class="modal large-footer-modal" tabindex="-1" aria-hidden="true" transition:fade="{{duration: 100}}">
        <div class="modal-dialog large-footer-modal-dialog selected-apartment-modal-dialog">
            <div class="modal-content large-footer-modal-content">
                <div class="modal-body large-footer-modal-body">
                    
                    <div class="header">
                        <div class="heading-title-wrapper">
                            <i class="fas fa-circle-info info-icon"></i>
                            <p>Apartment Details</p>
                        </div>
                        <div on:click={() => selectedApartment = null}>
                            <i class="fas fa-xmark close-icon"></i>
                        </div>
                    </div>

                    <div class="large-footer-modal-body-data selected-apartment-large-footer-modal-body-data">
                        <div class="data-details-selected-apartment">
                            <img src='images/apts-bg.png' alt="Selected Apartment Background" />

                            <div class="search-wrapper">
                                <div class="apt-details">
                                    <p class="heading">{selectedApartment.apartmentData.label}</p>
                                    <p class="tenant-count">{tenantsResult.length.toLocaleString()} Tenants</p>
                                </div>

                                <div class="search-actions">
                                    <div class="search-bar">
                                        <input placeholder="Search Tenant" bind:value={searchTerm} />
                                        <i class="fas fa-magnifying-glass"></i>
                                    </div>
                                    <button>
                                        <i class="fas fa-location-dot"></i>Set Waypoint
                                    </button>
                                </div>
                            </div>

                            <hr />

                            <div class="tenant-wrapper">
                                {#each tenantsResult as tenant}
                                    <div class="tenant-row">
                                        <div class="img-wrapper">

                                        </div>

                                        <div class="tenant-details">
                                            <p class="tenant-name">{tenant}</p>
                                            <p class="tenant-status">Current Tenant</p>
                                        </div>
                                    </div>
                                {/each}
                            </div>
                        </div>
                    </div>

                    <div class="large-footer-modal-footer-selected-apartment">
                        <input placeholder="New ID" bind:value={tempSrc} />
                        <button class="add-button" on:click={addNewTenant}>
                            Add
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/if}