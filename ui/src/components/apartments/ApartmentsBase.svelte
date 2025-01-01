<script lang="ts">
	import ApartmentCard from "@components/apartments/ApartmentCard.svelte"
    import { APARTMENTS } from '@store/stores'
    import type { Apartment } from '@typings/type'
	import SelectedApartment from "./SelectedApartment.svelte"

    let selectedApartment: Apartment | null = null;
</script>

<section class="apartments-container">
    <h1>All Apartments</h1>

    <div class="apartment-listings">
        {#key $APARTMENTS}
            {#each $APARTMENTS as apartment, i}
                <ApartmentCard 
                    id={"apt-card-" + i}
                    {apartment}
                    selected={apartment => selectedApartment = apartment} 
                />
            {/each}
        {/key}
    </div>
</section>


{#if selectedApartment}
    <SelectedApartment bind:selectedApartment />
{/if}

<style>
    .apartments-container {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

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

