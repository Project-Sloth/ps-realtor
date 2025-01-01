<script lang="ts">
    import Tile from '@components/generic/Tile.svelte'
    import { PROPERTIES } from '@store/stores'
    import type { Apartment } from '@typings/type'

    export let id = "apt-card-0";
    export let apartment: Apartment;
    export let selected: (apartment: Apartment) => void;
    

    let apartmentData: any;
    let tenants: string[] = [];
    let apartmentName: string;

    $: apartmentData = apartment?.apartmentData || {};

    $: if (apartment) {
        apartmentName = apartment?.apartmentData.label as string;
        const arrCitizenids = $PROPERTIES.filter((property) => property.apartment === apartmentName).map((property) => property.owner);

        if (arrCitizenids.length !== 0 && arrCitizenids[0] !== undefined) {
            apartmentData.currentTenants = arrCitizenids.length;
        } else {
            apartmentData.currentTenants = 0;
        }
    }
</script>

<button {id} class="apartment-card" on:click={() => selected(apartment)}>
    <section class="apartment-banner">
        <img class="apartment-banner" src={apartmentData.imgs?.[0]?.url} alt="Apartment Thumbnail" />
        <Tile icon="fa-building-user">{apartmentData.currentTenants || 0} Tenants</Tile>
    </section>
    

    <section class="apartment-details">
        <h2>{apartmentData.label}</h2>
        <small style="color: var(--light-border-color-8);">Legion Square</small>
    </section>
</button>

<style>
    .apartment-card {
		display: flex;
		flex-direction: column;

		border-radius: 3px;
		box-shadow: 0px 4px 4px 0px rgba(0, 0, 0, 0.25);

		background-color: var(--light-border-color-2);
		transition: transform .15s ease-out;

		text-align: unset;
    }

    .apartment-banner {
        width: 100%;
        border-radius: 3px;
        position: relative;        
    }

    .apartment-banner > img {
        object-fit: cover;
        width: 100%;
        height: 13rem;
    }

    .apartment-banner > :global(.tile) {
        position: absolute;
        bottom: .25rem;
        right: .25rem;
        --tile-color: rgba(36, 36, 36, 0.7);
        --tile-icon-color: var(--green-color);
    }

    .apartment-details {
        display: flex;
        flex-direction: column;
        padding: 0.5rem 1rem;
    }
</style>
