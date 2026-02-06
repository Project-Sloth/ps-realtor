<script lang="ts">
	import Dropdown, { type LabelValue } from './Dropdown.svelte'

	const onValue = 'on';
	const offValue = 'off';
	
	export let id: string | null = null;
    export let onLabel = 'on';
    export let offLabel = 'off';
	export let value: boolean;
	export let prefix: string = '';
	export let flex = false;
	export let changed: (value: boolean, label: string) => void = () => null;

	const items: LabelValue<string>[] = [
		{ label: onLabel, value: onValue },
		{ label: offLabel, value: offValue },
	]

	function select(innerValue: string) {
		value = innerValue === onValue ? true : false;
		changed(value, value ? onLabel : offLabel);
	}
</script>

<Dropdown
	{id} {items} {prefix} {flex}
	value={value ? onValue : offValue}
	changed={value => select(value)}
/>
