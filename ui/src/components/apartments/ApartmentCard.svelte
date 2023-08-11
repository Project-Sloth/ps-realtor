<script lang="ts">
    import type { IApartment } from '@typings/type'
	import { fly } from 'svelte/transition'

	export let selectedApartment: IApartment = null, apartment: IApartment = null, id="apt-card-0";

	// cbf with typescript rn
	let apartmentData: any = apartment.apartmentData
</script>

<div class="apartment-card-wrapper" id={id} 
    on:click={() => (selectedApartment = apartment)}
	in:fly={{ y: 10, duration: 250 }} >
    
    <img src={apartmentData.imgs[0].url} />

    <div class="details">
        <p class="heading">{apartmentData.label}</p>

        <p class="info">Legion Square</p>

        <div class="location-tenants-info">
            <img src="images/user-location-pin.png" />
            <p>100 / 150 Global tenants</p>
        </div>

        <button class="select-apt-button">
            Select Apartment
        </button>
    </div>
</div>