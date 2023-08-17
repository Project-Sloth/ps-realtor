<script>
	import { createEventDispatcher } from 'svelte'

	const dispatch = createEventDispatcher()

	export let dropdownValues,
		label,
		selectedValue,
		id = 'array-dd',
		insideLabel = ''

	let isOpen = false

	function toggleDropdown() {
		isOpen = !isOpen

		const selectWrapper = document.getElementById('select')
		if (isOpen) {
			selectWrapper.style.borderBottomLeftRadius = '0'
			selectWrapper.style.borderBottomRightRadius = '0'
		} else {
			selectWrapper.style.borderBottomLeftRadius = '0.2vw'
			selectWrapper.style.borderBottomRightRadius = '0.2vw'
		}
	}

	function selectDropdownValue(value) {
		selectedValue = value
		dispatch('selected-dropdown', value)
		isOpen = false
	}
</script>

<div class="dropdown" {id}>
	{#if label?.trim() !== ''}
		<label for="dd">{label}: </label>
	{/if}
	<div class="dropdown-wrapper">
		<div class="select-wrapper" id="select" on:click={toggleDropdown}>
			{#if selectedValue?.trim() !== ''}
				<div class="select-wrapper-selected-value">
					{#if insideLabel?.trim() !== ''}
						<p class="inside-label">{insideLabel}</p>
					{/if}
					<p class="selected-value-text">{selectedValue}</p>
				</div>
			{:else}
				<div />
			{/if}
			<i class="fas fa-chevron-down dropdown-chevron" />
		</div>
		{#if isOpen}
			<div class="options-wrapper">
				{#if dropdownValues.length < 1}
					<div class="no-items-found">No items found</div>
				{:else}
					{#each dropdownValues as ddValue}
						<div
							class="option-child"
							on:click={() => {
								selectDropdownValue(ddValue)
							}}
						>
							<p>
								{ddValue}
								{#if selectedValue === ddValue}
									<i class="fas fa-check icon" />
								{/if}
							</p>
						</div>
					{/each}
				{/if}
			</div>
		{/if}
	</div>
</div>
