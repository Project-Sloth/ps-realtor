<script lang="ts" context="module">
	let hideCurrent: () => void;
	
	export type LabelValue<TValue = string> = { label: string, value: TValue };
	window.addEventListener('pointerdown', () => hideCurrent && hideCurrent());

</script>

<script lang="ts">
	export let id: string | null = null;
	export let items: LabelValue<string>[];
	export let value: string;
	export let prefix: string = '';
	export let overflowX = false;
	export let overflowY = false;
	export let flex = false;
	export let changed: (value: string, label: string) => void = () => null;

	$: selected = items.find(i => i.value === value);

	let open = false;

	function show() {
		open = true;

		if (hideCurrent !== hide) {
            hideCurrent && hideCurrent();
            hideCurrent = hide;
        }
	}

	function hide() {
		open = false;
	}

	function toggle() {
		open ? hide() : show();
	}

	function select(item: LabelValue) {
		value = item.value;
		changed(item.value, item.label);
		open = false;
	}
</script>

<div class="dropdown-container" class:open class:flex on:pointerdown|stopPropagation>
	<button id={id} class="dropdown-option" on:click={toggle}>
		<span>
			<span class="dropdown-prefix">{prefix}</span>
			{selected?.label}
		</span>
		<i class="fas fa-chevron-down dropdown-chevron visible" />
	</button>

	<article
		class="dropdown-options" 
		class:open
		class:dropdown-overflow-x={overflowX} 
		class:dropdown-overflow-y={overflowY}>
		{#if !items.length}
			<div class="dropdown-option">No items found</div>
		{:else}
			{#each items as item}
				<button class="dropdown-option" on:click={() => select(item)}>
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

		width: min-content;
		background: var(--dropdown-background);
	}

	.dropdown-container.open {
		border-bottom-right-radius: 0;
		border-bottom-left-radius: 0;
	}

	.dropdown-container.flex {
		flex: 1;
	}

	.dropdown-chevron {
		color: var(--less-light-border-color);
	}

	.dropdown-prefix {
		color: var(--less-light-border-color);
	}

	.dropdown-options {
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

	.dropdown-options.dropdown-overflow-x {
		width: unset;
		max-width: unset;
		min-width: calc(100% + var(--dropdown-border-size) * 2);
	}

	.dropdown-options.open {
		max-height: 10rem;
		overflow-y: auto;
		border: var(--dropdown-border);
		border-top-right-radius: 0;	
	}

	.dropdown-options.open.dropdown-overflow-x {
		border-top-right-radius: 0.2vw;
	}

	.dropdown-options.open.dropdown-overflow-y {
		max-height: max-content;
		overflow-y: visible;
	}

	.dropdown-option {
		display: flex;
		flex-direction: row;

		padding: 0.25rem 0.5rem;
		place-items: center;
		text-align: left;

		min-width: 0;
		gap: 0.5rem;
	}

	.dropdown-option > span {
		white-space: nowrap;
		overflow-x: hidden;
		text-overflow: ellipsis;
		flex: 1;
	}

	.dropdown-option > i {
		visibility: hidden;
		flex-shrink: 0;
	}

	.dropdown-option > i.visible {
		visibility: visible;
	}

	.dropdown-option:hover {
		background-color: var(--black-two-opaque-color);
	}
</style>
