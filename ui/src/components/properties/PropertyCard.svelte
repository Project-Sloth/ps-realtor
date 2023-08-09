<script lang="ts">
    import type { IProperty } from '@typings/type'
	import { REALTOR_GRADE, SHELLS } from '@store/stores'
	import { fly } from 'svelte/transition'

    export let id = "property-card-1", property: IProperty = null, selectedProperty: IProperty = null;
</script>

<div id={id} class="property-card-wrapper group">
    
    <button class="invisible group-hover:visible absolute card-hover-button" on:click={() => (selectedProperty = property)} in:fly={{ y: 10, duration: 250 }}>
        View Property
    </button>
    
    {#if property.extra_imgs[0] ? property.extra_imgs[0].url : $SHELLS[property.shell].imgs[0].url}
		<img src={property.extra_imgs[0] ? property.extra_imgs[0].url : $SHELLS[property.shell].imgs[0].url} />
	{:else}
        <img src="/images/property-card-img.png" />
	{/if}
    

    <div class="property-card-details">
        <p class="property-name">{property.label}</p>
        <p class="property-address">{property.street ? property.street + " - " : property.apartment ? property.apartment + " - " : ''} {property.property_id}  {property.region ? " - " + property.region : ''}</p>
        <p class="property-cost">$ {property.price?.toLocaleString()} USD</p>
        <div class="property-details">
            {#if $REALTOR_GRADE >= 0 && property.for_sale}
                <div class="each-tile">
                    <i class="fas fa-dollar-sign"></i>
                    For Sale
                </div>
            {/if}

            <div class="each-tile">
                <i class="fas fa-image"></i>
                Gallery: {$SHELLS[property.shell] ? $SHELLS[property.shell].imgs.length : 0}
            </div>

            <div class="each-tile">
                <i class="fas fa-house-chimney"></i>
                {property.shell}
            </div>

            <div class="each-tile">
                <i class="fas fa-truck-front"></i>
                Garage: {property.garage_data ? Object.keys(property.garage_data).length > 0 ? 'Yes' : 'No' : 'No'}
            </div>
        </div>
    </div>
</div>