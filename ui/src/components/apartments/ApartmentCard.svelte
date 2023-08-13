<script lang="ts">
    import type { IApartment } from '@typings/type'
    import { fly } from 'svelte/transition'
    import { PROPERTIES } from '@store/stores'
    import { SendNUI } from '@utils/SendNUI'
    import { onMount } from 'svelte'

    export let selectedApartment: IApartment = null;
    export let apartment: IApartment = null;
    export let id="apt-card-0";

    let apartmentData: any;
    let tenants: string[] = [];
    let apartmentName: string;

    $: apartmentData = apartment?.apartmentData || {};

    $: if (apartment) {
        apartmentName = apartment?.apartmentData.label as string;
        const arrCitizenids = $PROPERTIES.filter((property) => property.apartment === apartmentName).map((property) => property.owner);

        if (arrCitizenids.length !== 0 && arrCitizenids[0] !== undefined) {
            SendNUI('getNames', arrCitizenids).then((names: string[]) => {
                tenants = names;
                apartmentData.currentTenants = tenants.length;
            })
        } else {
            apartmentData.currentTenants = 0;
        }
    }
</script>

<div class="apartment-card-wrapper" id={id} 
    on:click={() => (selectedApartment = apartment)}
    in:fly={{ y: 10, duration: 250 }} >
    
    <img src={apartmentData.imgs?.[0]?.url} alt="Apartment Thumbnail" />

    <div class="details">
        <p class="heading">{apartmentData.label}</p>
        <p class="info">Legion Square</p>

        <div class="location-tenants-info">
            <img src="images/user-location-pin.png" alt="User Location Icon" />
            <p>{tenants.length || 0} Global Tenants</p>
        </div>

        <button class="select-apt-button">
            Select Apartment
        </button>
    </div>
</div>