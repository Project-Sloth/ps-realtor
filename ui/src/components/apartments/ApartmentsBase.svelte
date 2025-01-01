<script lang="ts">
	import ApartmentCard from "@components/apartments/ApartmentCard.svelte"
    import { APARTMENTS } from '@store/stores'
    import type { Apartment } from '@typings/type'
	import SelectedApartment from "./SelectedApartment.svelte"

    let selectedApartment: Apartment | null = null;
</script>

<h1>All Apartments</h1>

<section class="apartment-listings">
    {#key $APARTMENTS}
        {#each $APARTMENTS as apartment, i}
            <ApartmentCard 
                id={"apt-card-" + i}
                {apartment}
                selected={apartment => selectedApartment = apartment} 
            />
        {/each}
    {/key}
</section>

{#if selectedApartment}
    <SelectedApartment bind:selectedApartment />
{/if}

<style>
    .apartment-listings {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr));
		grid-auto-rows: 1fr;

		gap: 1rem;
		overflow-y: auto;

		flex: 1;
		padding: 0 1rem .5rem 1rem;
    }
</style>

