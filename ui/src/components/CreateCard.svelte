<script lang="ts">
	import { ReceiveNUI } from '@utils/ReceiveNUI'
	import { SendNUI } from '@utils/SendNUI'
	import { SHELLS, TEMP_HIDE } from '@store/stores'
    import { fly } from 'svelte/transition';

    export let isCreating: boolean = false

	let description: string = ''
	let for_sale: boolean = true
	let price: number = 0
	let shell: string = ''
	let door_data: any = null
	let garage_data: any = null

    let valid: boolean = false

	ReceiveNUI('createdDoor', (data) => {
		door_data = data
	})

	ReceiveNUI('createdGarage', (data) => {
		garage_data = data
	})

    $: {
        valid = description.length > 0 && price > 0 && shell.length > 0 && door_data
        SendNUI('create:setTextFields', {
            description: description,
            for_sale: for_sale,
            price: price,
            shell: shell,
        })
    }
</script>

<div
	class="max-w-[60%] h-fit bg-[color:var(--color-secondary)] flex flex-col gap-4 p-5"
    in:fly={{ y: 10, duration: 250 }}
>

	<!-- Description -->
	<div class="flex flex-row gap-2 items-center w-full">
		<p class="text-2xl font-bold">Description</p>
		<textarea
			class="text-2xl bg-[color:var(--color-tertiary)] p-2 w-full"
			bind:value={description}
		/>
	</div>

	<div class="flex flex-row gap-2 items-center w-full">
		<p class="text-2xl font-bold">Price</p>
		$<input
			type="number"
			class="text-2xl bg-[color:var(--color-tertiary)] p-2 w-full"
			bind:value={price}
		/>
	</div>
	<!-- Shell -->
	<div class="flex flex-row gap-2 items-center w-full">
		<p class="text-2xl font-bold">Shell Type</p>
		<select
			class="text-2xl bg-[color:var(--color-tertiary)] p-2"
			bind:value={shell}
		>
			{#each Object.keys($SHELLS) as shell}
				<option value={shell}>{shell}</option>
			{/each}
		</select>
	</div>

	<div class="flex flex-row gap-2 items-center w-full">
		<p class="text-2xl font-bold">Set Door</p>
		<div
			class="bg-[color:var(--color-tertiary)] flex flex-row px-2 items-center"
		>
			{door_data ? 'Set' : 'Not Set'}
			<div class=" aspect-square grid place-items-center p-2">
				<i
					class="fas text-2xl fa-{door_data
						? 'check'
						: 'times'} text-2xl"
				/>
			</div>
		</div>
		<button
			class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
			on:click={() => {
                SendNUI('create:createZone', { type: 'door' })
                $TEMP_HIDE = true
            }}
		>
			<i class="fas fa-pen" />
			<p>{door_data ? 'Edit' : 'Create'}</p>
		</button>
	</div>

    <div class="flex flex-row gap-2 items-center w-full">
		<p class="text-2xl font-bold">Set Garage</p>
		<div
			class="bg-[color:var(--color-tertiary)] flex flex-row px-2 items-center"
		>
			{garage_data ? 'Garage Set' : 'Not Garage'}
			<div class=" aspect-square grid place-items-center p-2">
				<i
					class="fas text-2xl fa-{door_data
						? 'check'
						: 'times'} text-2xl"
				/>
			</div>
		</div>
		<button
			class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
			on:click={() => {
                if (garage_data) {
                    SendNUI('create:removeGarage', {})
                } else {
                    SendNUI('create:createZone', { type: 'garage' })
                    $TEMP_HIDE = true
                }
            }}
		>
			<i class="fas fa-pen" />
			<p>{garage_data ? 'Remove' : 'Create'}</p>
		</button>
	</div>

    {#if valid}
        <button class="flex flex-row gap-2 items-center w-full bg-[color:var(--color-tertiary)] justify-center py-2"
            on:click={()=>{
                SendNUI("create:confirmListing")
                isCreating = false
            }}
        >
            <i class="fas fa-plus" />
            Create Property
        </button>
    {/if}
</div>
