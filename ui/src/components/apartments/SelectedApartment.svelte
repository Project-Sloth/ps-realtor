<script lang="ts">
	import Button from '@components/generic/Button.svelte'
	import Card from '@components/generic/Card.svelte'
	import Modal from '@components/generic/Modal.svelte'
	import { PROPERTIES } from '@store/stores'
	import type { Apartment } from '@typings/type'
	import { SendNUI } from '@utils/SendNUI'
	import { onMount } from 'svelte'

    export let selectedApartment: Apartment | null = null;

    let tenants: string[] = [], tenantsResult: string[] = [];
    let searchTerm: string = "";
    let tempSrc: string | null = null;

    onMount(()=>{
        const apartmentName: string = selectedApartment?.apartmentData.label ?? 'APARTMENT_NAME'
        
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
            apartment: selectedApartment?.apartmentData.label, 
            targetSrc: tempSrc
        });
        
        selectedApartment = null;
    }

    function getInitals(name: string) {
        return name.trim().split(' ').map(i => i[0]).join('').toUpperCase();
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
    <Modal open={!!selectedApartment} closed={() => selectedApartment = null}>
        <Card title="Apartment Details">
            <i class="fas fa-circle-info" slot="icon" style="color: var(--blue-color);" />

            <button slot="header-action" on:click={() => selectedApartment = null}>
                <i class="fas fa-xmark close-icon"></i>
            </button>

            <img class="apartment-banner" src="images/apartment-banner.webp" alt="Apartments Background" />

            <h2>{selectedApartment.apartmentData.label}</h2>

            <section class="apartment-search">
                <div class="apartment-search-bar">
                    <input
                        type="text"
                        placeholder="Search Tenant"
                        bind:value={searchTerm}
                    />
                    <i class="fas fa-magnifying-glass" />
                </div>                
                <div class="spacer"></div>
                <span>{tenantsResult.length.toLocaleString()} Tenants</span>
                <Button status="primary" icon="fa-location-dot" click={() => SendNUI('setWaypoint', selectedApartment?.apartmentData.door)}>Set Waypoint</Button>
            </section>

            
            <section class="apartment-tenants">
                {#each tenantsResult as tenant}
                    <article class="tenant-card">
                        <section class="tenant-card-avatar"><span>{getInitals(tenant)}</span></section>
                        <section class="tenant-card-content">
                            <p>{tenant}</p>
                            <small>Current Tenant</small>
                        </section>                        
                    </article>
                {:else}
                    <p class="empty">No tenants found.</p>
                {/each}
            </section>
            
            <section class="apartment-actions" slot="footer">
                <input class="form-control" placeholder="New ID" bind:value={tempSrc} />
                <Button status="primary" click={addNewTenant}>Add</Button>
            </section>
        </Card>
    </Modal>
{/if}

<style>
    .apartment-banner {
        max-height: 10rem;
        object-fit: cover;
        border-radius: 12px;
        object-position: 0 25%;
    }

    .apartment-search {
        display: flex;
        flex-direction: row;
        place-items: center;
        gap: 1rem;
    }

    .apartment-search-bar {
		display: flex;
		place-items: center;

		padding-right: .5rem;
        border: 1px solid var(--light-border-color-2);
        border-radius: 3px;

        background: var(--control-background-gradient);
	}

	.apartment-search-bar > input {
        padding: .25rem .5rem;
        background: none;
    }

	.apartment-search-bar > i {
		color: var(--light-border-color-6);
	}

    .apartment-tenants {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        overflow-y: auto;
        padding: 0.25rem .5rem;
        flex: 1;
    }

    .apartment-tenants:has(.empty) {
        place-content: center;
        place-items: center;
        font-weight: 500;
    }

    .tenant-card {
        display: flex;
        flex-direction: row;
        gap: 1rem;
        place-items: center;

        padding-top: 1rem;
		border-top: 0.1px solid var(--light-border-color-2);
    }

    .tenant-card:first-child {
        border-top: none;
    }

    .tenant-card-avatar {
        width: 2.5rem;
        height: 2.5rem;
        border-radius: 50%;
        background-color: var(--light-border-color-2);

        display: grid;
        place-items: center;
        font-weight: 500;
        pointer-events: none;
    }

    .tenant-card-content {
        font-weight: 500;
        line-height: 1rem;
        flex: 1;
    }

    .tenant-card-content > small {
        color: var(--light-border-color-8);
    }

    .apartment-actions {
        display: flex;
        flex-direction: row;
        gap: 1rem;
    }
</style>