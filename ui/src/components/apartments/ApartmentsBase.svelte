<script lang="ts">
	import ApartmentCard from "@components/apartments/ApartmentCard.svelte"
    import { APARTMENTS } from '@store/stores'
    import type { IApartment } from '@typings/type'
	import SelectedApartment from "./SelectedApartment.svelte"

    let selectedApartment: IApartment  = null;

    $: {
        if(selectedApartment) {
            console.log("apartment selected: ", selectedApartment)
        }
    }
</script>
<div class="apartments-base">
    <div class="heading">
        All Apartments
    </div>

    {#key $APARTMENTS}
        <div class="apartment-listing-wrapper">
            {#each $APARTMENTS as apartment, i}
                <ApartmentCard bind:selectedApartment apartment={apartment} id={"apt-card-" + i} />
            {/each}
        </div>
    {/key}

    {#if selectedApartment}
        <SelectedApartment bind:selectedApartment />
    {/if}
</div>