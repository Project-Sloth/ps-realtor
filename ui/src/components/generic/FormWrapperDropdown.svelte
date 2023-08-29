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

<div class="form-dropdown" {id}>
	{#if label?.trim() !== ''}
		<label for="dd">{label}: </label>
	{/if}
	<div class="form-dropdown-wrapper">
		<div class="form-select-wrapper" id="select" on:click={toggleDropdown}>
			{#if selectedValue?.trim() !== ''}
				<div class="form-select-wrapper-selected-value">
					{#if insideLabel?.trim() !== ''}
						<p class="form-inside-label">{insideLabel}</p>
					{/if}
					<p class="form-selected-value-text">{selectedValue}</p>
				</div>
			{:else}
				<div />
			{/if}
			<i class="fas fa-chevron-down form-dropdown-chevron" />
		</div>
		{#if isOpen}
			<div class="form-options-wrapper">
				{#if dropdownValues.length < 1}
					<div class="form-no-items-found">No items found</div>
				{:else}
					{#each dropdownValues as ddValue}
						<div
							class="form-option-child"
							on:click={() => {
								selectDropdownValue(ddValue)
							}}
						>
							<p>
								{ddValue}
								{#if selectedValue === ddValue}
									<i class="fas fa-check form-icon" />
								{/if}
							</p>
						</div>
					{/each}
				{/if}
			</div>
		{/if}
	</div>
</div>

<style>
	.form-dropdown {
		display: flex;
		flex-direction: row;
		/* font-size: 0.9vw; */

		z-index: 1;

		position: absolute;
	}

	.form-dropdown > label {
		margin: 0 0.2vw;
		color: var(--light-text);
	}

	.form-dropdown-wrapper {
		display: flex;
		flex-direction: column;

		min-width: 10vw;
		width: fit-content;
		/* padding: 0 0.2vw; */

		background: linear-gradient(0deg, #313131, #313131),
			linear-gradient(
				0deg,
				var(--light-border-color-2),
				var(--light-border-color-2)
			);
		border: 1px solid var(--light-border-color-2);

		color: var(--app-name);
		border-radius: 0.1vw;
	}

	.form-select-wrapper {
		width: auto;
		/* height: 1.5vw; */

		display: flex;
		flex-direction: row;
		justify-content: space-between;
		padding-left: 0.2vw;
		padding-right: 0.3vw;

		cursor: pointer;
	}

	.form-select-wrapper-selected-value {
		font-size: 0.6vw;
		padding: 0.15vw 0.2vw 0.25vw 0.2vw;
		margin-right: 0.2vw;

		display: flex;
		flex-direction: row;
	}
	.form-select-wrapper-selected-value > .form-inside-label {
		color: var(--less-light-border-color);
		margin-right: 0.3vw;
		padding-top: 0.055vw;
	}
	.form-select-wrapper-selected-value > .form-selected-value-text {
		padding-top: 0.07vw;
	}

	.form-dropdown-chevron {
		text-align: center;
		font-size: 0.5vw;
		margin-top: 0.5vw;

		color: var(--less-light-border-color);
	}

	.form-options-wrapper {
		width: 100%;
		min-height: 1vw;
		max-height: 7vw;
		overflow-y: auto;
	}

	.form-options-wrapper > .form-no-items-found {
		font-size: 0.5vw;
		padding: 0.1vw 0.6vw 0.4vw 0.7vw;
	}

	.form-option-child {
		cursor: pointer;

		padding: 0.17vw 0.8vw 0.17vw 0.7vw;
		min-height: 1.7vw;
		border-radius: 0.2vw;
		font-size: 0.6vw;
	}

	.form-option-child > p {
		display: flex;
		flex-direction: row;
		padding-top: 0.2vw;
	}
	.form-option-child > p > .form-icon {
		font-size: 0.6vw;
		padding-top: 0.2vw;
		margin-left: 0.5vw;
	}

	.form-option-child:hover {
		background-color: var(--black-two-opaque-color);
	}
</style>
