<script lang="ts">
	import type { IApartment } from "@typings/type"
    import { SendNUI } from "@utils/SendNUI"

    export let selectedApartment: IApartment = null


    let tempSrc: string = null

    let areYouSure: boolean = false
</script>



{#if selectedApartment !== null}
	<div
		class="flex flex-col gap-4 h-full overflow-y-scroll scroll-style scroll-style-vertical w-full"
	>
    <h1 class="text-3xl font-bold mb-2">Add New Tenant</h1>
        <div class="flex flex-row gap-2">
            <input type="text" class="w-full p-2 bg-[color:var(--color-tertiary)]" placeholder="ID" bind:value={tempSrc} />
            <button class="w-fit px-4 py-2 bg-[color:var(--color-tertiary)]"
            on:click={() => {
                areYouSure = true
            }}
            >Add</button>
        </div>
        {#if areYouSure}
        <p class="text-2xl font-bold">Are you sure?</p>
        <div class="flex flex-row gap-2">
            <button class="w-fit px-4 py-2 bg-[color:var(--color-tertiary)]"
            on:click={() => {
                SendNUI('addTenantToApartment', {apartment: selectedApartment.apartmentData.label, targetSrc: tempSrc})
                areYouSure = false
                selectedApartment = null
            }}
            >Yes</button>
            <button class="w-fit px-4 py-2 bg-[color:var(--color-tertiary)]"
            on:click={() => {
                areYouSure = false
            }}
            >No</button>
        </div>
        {/if}
    </div>
{/if}