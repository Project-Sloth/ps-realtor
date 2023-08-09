<script lang="ts">
	import type { ITab } from '@typings/type'
	import { SendNUI } from '@utils/SendNUI'
	import { onMount } from 'svelte';

	export let AvailableTabs: ITab[] = []
	/* The current Selected Tab */
	export let selectedTab: ITab = AvailableTabs[0]

	let showBlipMenu = false

	let x
	let y

	let showBlipsForSale = false
	let showBlipsOwned = false

	onMount(() => {
		SendNUI('getBlipBooleans', {}).then((data) => {
			showBlipsForSale = data.showBlipsForSale
			showBlipsOwned = data.showBlipsOwned
		})
	})
</script>

<div
	class="w-full h-fit p-4 bg-[color:var(--color-secondary)] flex flex-row gap-4 items-center justify-center"
>
	<button
	class="w-fit blip-button px-8 h-[5rem] bg-[color:var(--color-tertiary)] items-center justify-center flex flex-row gap-4"
		on:click={() => {
			const btnLoc = document.querySelector('.blip-button').getBoundingClientRect()
			//set x and y to be on top of the button
			x = btnLoc.x
			y = btnLoc.y - 100
			showBlipMenu = !showBlipMenu
			}}
	>
		<i class=" fas fa-map-pin" />
		<p>Blips</p>
	</button>

	{#each AvailableTabs as tab}
		<button
			class="w-fit px-8 h-[5rem] bg-[color:var(--color-tertiary)] items-center justify-center flex flex-row gap-4"
			class:active={selectedTab.name == tab.name}
			on:click={() => (selectedTab = tab)}
		>
			<i class={tab.icon} />
			<p>{tab.name}</p>
		</button>
	{/each}
</div>

{#if showBlipMenu}
<div class="w-fit h-fit p-4 flex flex-col gap-2 absolute bg-[color:var(--color-tertiary)] "
	style="top: {y}px; left: {x}px;"
>
	<label class="control control-checkbox">
        For Sale Houses
            <input type="checkbox" checked={showBlipsForSale}
			on:change={() => {
				showBlipsForSale = !showBlipsForSale
				SendNUI('showBlipsForSale', showBlipsForSale)
			}}
			/>
		<div class="control_indicator"></div>
	</label>
	<label class="control control-checkbox">
		Owned Houses
            <input type="checkbox" checked={showBlipsOwned}
				on:change={() => {
					showBlipsOwned = !showBlipsOwned
					SendNUI('showBlipsOwned', showBlipsOwned)
				}}
			/>
        <div class="control_indicator"></div>
    </label>
</div>
{/if}


<style>
	.active {
		background-color: var(--color-accent);
	}

	.control {
    font-family: arial;
    display: block;
    position: relative;
    padding-left: 30px;
    margin-bottom: 5px;
    padding-top: 0px;
    cursor: pointer;
    font-size: 16px;
}
    .control input {
        position: absolute;
        z-index: -1;
        opacity: 0;
    }
.control_indicator {
    position: absolute;
    top: 2px;
    left: 0;
    height: 20px;
    width: 20px;
    background: #e6e6e6;
    border: 0px solid #000000;
    border-radius: 0px;
}
.control:hover input ~ .control_indicator,
.control input:focus ~ .control_indicator {
    background: #cccccc;
}

.control input:checked ~ .control_indicator {
    background: var(--color-accent);
}
.control:hover input:not([disabled]):checked ~ .control_indicator,
.control input:checked:focus ~ .control_indicator {
    background: #0e6647d;
}
.control input:disabled ~ .control_indicator {
    background: #e6e6e6;
    opacity: 0.6;
    pointer-events: none;
}
.control_indicator:after {
    box-sizing: unset;
    content: '';
    position: absolute;
    display: none;
}
.control input:checked ~ .control_indicator:after {
    display: block;
}
.control-checkbox .control_indicator:after {
    left: 8px;
    top: 4px;
    width: 3px;
    height: 8px;
    border: solid #ffffff;
    border-width: 0 2px 2px 0;
    transform: rotate(45deg);
}
.control-checkbox input:disabled ~ .control_indicator:after {
    border-color: #7b7b7b;
}
.control-checkbox .control_indicator::before {
    content: '';
    display: block;
    position: absolute;
    left: 0;
    top: 0;
    width: 4.5rem;
    height: 4.5rem;
    margin-left: -1.3rem;
    margin-top: -1.3rem;
    background: #2aa1c0;
    border-radius: 3rem;
    opacity: 0.6;
    z-index: 99999;
    transform: scale(0);
}
</style>

