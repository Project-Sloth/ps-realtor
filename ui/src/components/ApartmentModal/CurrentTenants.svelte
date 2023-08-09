<script lang="ts">
	import type { IApartment } from '@typings/type'
	import { onMount } from 'svelte/internal'
    import { PROPERTIES } from '@store/stores'
	import { SendNUI } from '@utils/SendNUI'

	export let selectedApartment: IApartment = null


	let tenants: string[] = []

    let tenantsResult: string[] = []
    let searchTerm: string = ""

    onMount(()=>{
        const  apartmentName: string = selectedApartment.apartmentData.label as string
        // search PROPERTIES for all the properties that have the same apartment name and return the owner
        const arrCitizenids = $PROPERTIES.filter((property) => property.apartment === apartmentName).map((property) => property.owner)
        if (arrCitizenids.length === 0 || arrCitizenids[0] === undefined) {
            tenantsResult = ['No tenants']
            return
        }
        SendNUI('getNames', arrCitizenids).then((names: string[]) => {
            tenants = names
        })
    })

    $: {
        if (searchTerm.length > 0) {
            tenantsResult = tenants.filter((tenant) => tenant.toLowerCase().includes(searchTerm.toLowerCase())) || ['No tenants']
        } else {
            tenantsResult = tenants || ['No tenants']
        }
    }
</script>

<div
	class="w-full max-h-[65rem] flex flex-col gap-2 items-center max-w-[60%] overflow-y-hidden"
>
	<h3 class="text-3xl font-bold py-2 h-full relative">Current Tenants</h3>
    <!-- search bar -->
    <input type="text" class="w-[60%] h-full p-2 bg-[color:var(--color-tertiary)]" placeholder="Search" />

	<div
		class="w-full h-fit relative flex flex-col gap-2 items-center justify-center p-2 overflow-y-scroll scroll-style scroll-style-vertical"
	>
		<!-- {#each selectedApartment.apartments as id} -->
		{#each tenantsResult as tenant}
			<div class="bg-[color:var(--color-tertiary)] w-full p-4 py-2">
				<p class="text-2xl">{tenant}</p>
			</div>
		{/each}
	</div>
</div>
