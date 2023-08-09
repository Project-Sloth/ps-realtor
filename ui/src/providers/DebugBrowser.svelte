<script lang="ts">
	import { debugData } from '../utils/debugData'
	import type { IProperty } from '@typings/type'

	let show = false
	//EXAMPLE

	// debugData([
	// 	{
	// 		action: 'setVisible',
	// 		data: true,
	// 	},
	// ])
	let properties: IProperty[] = []
	let debugProperty: IProperty = {
		property_id: 1,
		label: 'Test Property',
		description: 'This is a test property',
		shell: 'Modern Hotel',
		price: Math.floor(Math.random() * 1000000),
		for_sale: 1,
		extra_imgs: [
			{
				"url": "https://i.postimg.cc/QCJr7nWT/entry.webp",
				"label": "Entrance"
			},
			{
				"url": "https://i.postimg.cc/CMG09d6x/garage.webp",
				"label": "Garage"
			}
		],
		door_data: {
			x: 0,
			y: 0,
			z: 0,
			h: 0,
			length: 0,
			width: 0,
			locked: false,
		},
		garage_data: {
			x: 0,
			y: 0,
			z: 0,
		},
	}
	let options = [
		{
			component: 'Show',
			actions: [
				{
					name: 'show',
					action: 'setVisible',
					data: true,
				},
				{
					name: 'hide',
					action: 'setVisible',
					data: false,
				},
			],
		},
		{
			component: 'Properties',
			actions: [
				{
					name: "Add Property",
					custom: true,
					customFunction: () => {
						let newProperty = Object.assign({}, debugProperty)
						newProperty.property_id = properties.length + 1
						newProperty.price = Math.floor(Math.random() * 1000000)
						newProperty.for_sale = (Math.random() > 0.5 ? 1 : 0)
						let coords = {
							x: Math.floor(Math.random() * 1000000),
							y: Math.floor(Math.random() * 1000000),
							z: Math.floor(Math.random() * 1000000),
						}
						newProperty.garage = (Math.random() > 0.5 ? coords : null)
						properties = [...properties, newProperty]
						debugData([
							{
								action: 'setProperties',
								data: properties,
							},
						])
					},
				},
			],
		},
		{
			component: 'Is Realtor',
			actions: [
				{
					name: 'true',
					action: 'setRealtor',
					data: true,
				},
				{
					name: 'false',
					action: 'setRealtor',
					data: false,
				},
			],
		}
		// {
		// 	component: 'Example',
		// 	actions : [
		// 		{
		// 			name: "debugLocation",
		// 			custom: true,
		// 			customFunction: () => {
		// CUSTOM LOGIC
		// 			}
		// 		},
		// 		{
		// 			name: "toggle Show",
		// 			custom: true,
		// 			customFunction: () => {
		// CUSTOM LOGIC
		// 			}
		// 		},
		// 	]
		// },
	]
</script>

<div class="absolute top-0 left-1/2 z-[1000]">
	<button
		class="bg-red-500 text-white p-2"
		on:click={() => {
			show = !show
		}}
	>
		Show
	</button>
	{#if show}
		<div class="w-fit h-fit bg-gray-600 p-2">
			{#each options as option}
				<div class="flex flex-row gap-2 items-center m-1">
					<p class="text-white">{option.component}</p>
					{#each option.actions as action}
						<button
							class="bg-blue-500 text-white p-2"
							on:click={() => {
								if (action.custom == true) {
									action.customFunction()
									return
								}
								debugData([
									{
										action: action.action,
										data: action.data,
									},
								])
							}}
						>
							{action.name}
						</button>
					{/each}
				</div>
			{/each}
		</div>
	{/if}
</div>
