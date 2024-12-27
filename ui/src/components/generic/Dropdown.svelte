<script lang="ts" context="module">
	let hideCurrent: () => void;
	
	export type LabelValue<TValue = string> = { label: string, value: TValue };
	window.addEventListener('pointerdown', () => hideCurrent && hideCurrent());

</script>

<script lang="ts">	
	export let items: LabelValue<string>[];
	export let value: string;
	export let prefix: string = '';
	export let changed: (value: string, label: string) => void = () => null;

	$: selected = items.find(i => i.value === value);

	let open = false;

	function hide() {
		open = false;
	}

	function toggle() {
		open = !open;

		if (hideCurrent !== hide) {
            hideCurrent && hideCurrent();
            hideCurrent = hide;
        }
	}

	function select(item: LabelValue) {
		value = item.value;
		changed(item.value, item.label);
		open = false;
	}
</script>

<div class="dropdown-container" class:open={open} on:pointerdown|stopPropagation>
	<button class="select-option" id="select" on:click={() => toggle()}>
		<span>
			<span class="select-prefix">{prefix}</span>
			{selected?.label}
		</span>
		<i class="fas fa-chevron-down select-chevron visible" />
	</button>

	<article class="select-options" class:open={open}>
		{#if !items.length}
			<div class="select-option">No items found</div>
		{:else}
			{#each items as item}
				<button class="select-option" on:click={() => select(item)}>
					<span>{item.label}</span>
					<i class="fas fa-check icon" class:visible={value === item.value} />
				</button>
			{/each}
		{/if}
	</article>
</div>

<style>
	:root {
		--dropdown-background: linear-gradient(0deg, #242424, #242424), linear-gradient(0deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.1));
		--dropdown-border-size: 1px;	
		--dropdown-border: var(--dropdown-border-size) solid rgba(255, 255, 255, 0.3);
	}

	.dropdown-container {
		position: relative;
		display: flex;
		flex-direction: column;
		
		border: var(--dropdown-border);
		border-radius: 0.2vw;

		max-width: min-content;
		background: var(--dropdown-background);
	}

	.dropdown-container.open {
		border-bottom-right-radius: 0;
		border-bottom-left-radius: 0;
	}

	.select-chevron {
		color: var(--less-light-border-color);
	}

	.select-prefix {
		color: var(--less-light-border-color);
	}

	.select-options {
		position: absolute;

		top: calc(100% - var(--dropdown-border-size));
		left: calc(var(--dropdown-border-size) * -1);
		width: calc(100% + var(--dropdown-border-size) * 2);
		
		display: flex;
		flex-direction: column;
		background: var(--dropdown-background);
		
		border-radius: 0.2vw;
		z-index: 1;

		border-top-left-radius: 0;
		max-height: 0%;
		overflow: hidden;
	}

	.select-options.open {
		max-height: max-content;
		border: var(--dropdown-border);
		border-top-right-radius: 0;	
	}

	.select-option {
		display: flex;
		flex-direction: row;

		padding: 0.25rem 0.5rem;
		place-items: center;
		text-align: left;

		min-width: 0;
		gap: 0.5rem;
	}

	.select-option > span {
		white-space: nowrap;
		overflow-x: hidden;
		text-overflow: ellipsis;
		flex: 1;
	}

	.select-option > i {
		visibility: hidden;
		flex-shrink: 0;
	}

	.select-option > i.visible {
		visibility: visible;
	}

	.select-option:hover {
		background-color: var(--black-two-opaque-color);
	}
</style>
