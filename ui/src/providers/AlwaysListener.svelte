<script lang="ts">
	import { ReceiveNUI } from '@utils/ReceiveNUI'
	import { debugData } from '@utils/debugData'
	import {
		browserMode,
		visibility,
		REALTOR_GRADE,
		PROPERTIES,
		SHELLS,
		CONFIG,
		TEMP_HIDE,
		APARTMENTS,
	} from '@store/stores'

	function browserHideAndShow(e: KeyboardEvent) {
		if (e.key === '=') {
			$visibility = true
		}
	}

	ReceiveNUI('setBrowserMode', (data: boolean) => {
		browserMode.set(data)
		console.log('browser mode enabled')
		if (data) {
			window.addEventListener('keydown', browserHideAndShow)
		} else {
			window.removeEventListener('keydown', browserHideAndShow)
		}
	})

	ReceiveNUI('setRealtorGrade', (grade: number) => {
		$REALTOR_GRADE = grade
	})

	ReceiveNUI('setConfig', (data: any) => {
		$CONFIG = data
	})

	ReceiveNUI('setProperties', (data: any) => {
		$PROPERTIES = null
		$PROPERTIES = data
	})

	ReceiveNUI('updateProperty', (data: any) => {
		const property_id = data.property_id
		const index = $PROPERTIES.findIndex((p: any) => p.property_id === property_id)

		if (index !== -1) {
			$PROPERTIES[index] = data
		} else {
			$PROPERTIES.push(data)
		}

		$PROPERTIES = [...$PROPERTIES]
	})

	ReceiveNUI('setApartments', (data: any) => {
		$APARTMENTS = null
		$APARTMENTS = data
	})

	ReceiveNUI('updateApartment', (data: any) => {
		const label = data.apartmentData.label
		const index = $APARTMENTS.findIndex((p: any) => p.apartmentData.label === label)
		if (index !== -1) {
			$APARTMENTS[index] = data
		}

		$APARTMENTS = [...$APARTMENTS]
	})

	ReceiveNUI('setShells', (data: any) => {
		$SHELLS = data
	})

	debugData([
		{
			action: 'setVisible',
			data: true,
		},
	])

	debugData([
		{
			action: 'setBrowserMode',
			data: true,
		},
	])

	ReceiveNUI('setTempHide', (data: boolean) => {
		$TEMP_HIDE = data
	})

	const debugApartments = [
		{
			apartmentData: {
				imgs: [
					{
						label: 'Outside',
						url: 'https://cdn.discordapp.com/attachments/1102801782452785162/1106153553283784704/integrity.webp',
					},
				],
				label: 'Integrity Way',
				door: {
					x: 269.73,
					y: -640.75,
					width: 1,
					h: 249.07,
					z: 42.02,
					length: 1,
				},
			},
			apartments: {
				'1': true,
			},
		},
		{
			apartmentData: {
				imgs: [
					{
						label: 'Outside',
						url: 'https://cdn.discordapp.com/attachments/1102801782452785162/1106154069426458665/integrity_1.webp',
					},
				],
				label: 'South Rockford Drive',
				door: {
					x: -667.02,
					y: -1105.24,
					width: 1,
					h: 242.32,
					z: 14.63,
					length: 1,
				},
			},
			apartments: [],
		},
	]

    debugData([
        {
            action: 'setApartments',
            data: debugApartments,
        },
    ])

	const debugShells = {
		Garage: {
			imgs: [
				{
					url: 'https://i.postimg.cc/QCJr7nWT/entry.webp',
					label: 'Entrance',
				},
				{
					url: 'https://i.postimg.cc/CMG09d6x/garage.webp',
					label: 'Garage',
				},
			],
			doorOffset: {
				y: 0.0,
				z: 0.0,
				heading: 0.0,
				width: 2.0,
				x: 0.0,
			},
			hash: -1465633100,
			label: 'Garage',
		},
		'House 3': {
			imgs: [
				{
					url: 'https://i.postimg.cc/HLbdwtRd/angle1.webp',
					label: 'Angle 1',
				},
				{
					url: 'https://i.postimg.cc/C1YYmqpD/angle2.webp',
					label: 'Angle 2',
				},
				{
					url: 'https://i.postimg.cc/26wYJSCt/entry.webp',
					label: 'Entrance',
				},
			],
			doorOffset: {
				y: 0.0,
				z: 0.0,
				heading: 0.0,
				width: 2.0,
				x: 0.0,
			},
			hash: -944672758,
			label: 'House 3',
		},
		Store: {
			imgs: [
				{
					url: 'https://i.postimg.cc/wBmZJbCj/room-1.webp',
					label: 'Room 1',
				},
				{
					url: 'https://i.postimg.cc/vBwjvtyL/room-2.webp',
					label: 'Room 2',
				},
			],
			doorOffset: {
				y: 0.0,
				z: 0.0,
				heading: 0.0,
				width: 2.0,
				x: 0.0,
			},
			hash: -1894535671,
			label: 'Store',
		},
		'Standard Motel': {
			imgs: [
				{
					url: 'https://i.postimg.cc/q7PQTJZk/motel.webp',
					label: 'Motel',
				},
			],
			doorOffset: {
				y: -2.3,
				z: 0.0,
				heading: 90.0,
				width: 1.5,
				x: -0.5,
			},
			hash: 150799162,
			label: 'Standard Motel',
		},
		'Modern Hotel': {
			imgs: [
				{
					url: 'https://i.postimg.cc/BQ7T3ZXd/angle-1.webp',
					label: 'Angle 1',
				},
				{
					url: 'https://i.postimg.cc/SxXWx09j/angle-2.webp',
					label: 'Angle 2',
				},
			],
			doorOffset: {
				y: 4.35,
				z: 0.0,
				heading: 179.79,
				width: 2.0,
				x: 4.98,
			},
			hash: 1926141467,
			label: 'Modern Hotel',
		},
		'2 Floor House': {
			imgs: [
				{
					url: 'https://i.postimg.cc/TPfgqKS5/bathroom.webp',
					label: 'Bathroom',
				},
				{
					url: 'https://i.postimg.cc/9Mf9KvcW/entry.webp',
					label: 'Entrance',
				},
				{
					url: 'https://i.postimg.cc/MHMQKVcN/floor2.webp',
					label: 'Floor 2',
				},
				{
					url: 'https://i.postimg.cc/B6wF0Mv2/kitchen.webp',
					label: 'Kitchen',
				},
				{
					url: 'https://i.postimg.cc/MHCjcHVT/livingroom.webp',
					label: 'Living Room',
				},
				{
					url: 'https://i.postimg.cc/zXhgswYR/room1.webp',
					label: 'Room 1',
				},
				{
					url: 'https://i.postimg.cc/fWpdq2pN/room2.webp',
					label: 'Room 2',
				},
				{
					url: 'https://i.postimg.cc/TP0mkRM7/room3.webp',
					label: 'Room 3',
				},
				{
					url: 'https://i.postimg.cc/dV8Gy2WK/room3dresser.webp',
					label: 'Room 3 Dresser',
				},
			],
			doorOffset: {
				y: 0.0,
				z: 0.0,
				heading: 0.0,
				width: 2.0,
				x: 0.0,
			},
			hash: -1034449271,
			label: '2 Floor House',
		},
		Trailer: {
			imgs: [
				{
					url: 'https://i.postimg.cc/L5xHq67P/entranceandkitchen.webp',
					label: 'Entrance and Kitchen',
				},
				{
					url: 'https://i.postimg.cc/05n5XcQN/main.webp',
					label: 'Main',
				},
				{
					url: 'https://i.postimg.cc/qM7JPyhx/room1.webp',
					label: 'Room',
				},
			],
			doorOffset: {
				y: 0.0,
				z: 0.0,
				heading: 0.0,
				width: 2.0,
				x: 0.0,
			},
			hash: 2076152142,
			label: 'Trailer',
		},
		'House 2': {
			imgs: [
				{
					url: 'https://i.postimg.cc/251Brg1T/entry.webp',
					label: 'Entrance',
				},
				{
					url: 'https://i.postimg.cc/TwmLWmqD/hallway.webp',
					label: 'Hallway',
				},
				{
					url: 'https://i.postimg.cc/QMvKtS5D/kitchen.webp',
					label: 'Kitchen',
				},
				{
					url: 'https://i.postimg.cc/3NTyjRnb/mainarea.webp',
					label: 'Main Area',
				},
				{
					url: 'https://i.postimg.cc/mkyPmsnZ/room.webp',
					label: 'Room',
				},
			],
			doorOffset: {
				y: 0.0,
				z: 0.0,
				heading: 0.0,
				width: 2.0,
				x: 0.0,
			},
			hash: -1065164752,
			label: 'House 2',
		},
		Office: {
			imgs: [
				{
					url: 'https://i.postimg.cc/LXddbMtP/entry.webp',
					label: 'Entance',
				},
				{
					url: 'https://i.postimg.cc/L5RcmB06/office.webp',
					label: 'Office',
				},
			],
			doorOffset: {
				y: 0.0,
				z: 0.0,
				heading: 0.0,
				width: 2.0,
				x: 0.0,
			},
			hash: 444575403,
			label: 'Office',
		},
		'Apartment 2 Unfurnished': {
			imgs: [
				{
					url: 'https://i.postimg.cc/4404Tn6C/entry.webp',
					label: 'Entrance',
				},
				{
					url: 'https://i.postimg.cc/MKj6Zx5n/kitchen.webp',
					label: 'Kitchen',
				},
				{
					url: 'https://i.postimg.cc/qvVkzYDj/livingroom.webp',
					label: 'Living Room',
				},
			],
			doorOffset: {
				y: -6.5,
				z: -1.0,
				heading: 358.5,
				width: 1.5,
				x: 4.69,
			},
			hash: -886563882,
			label: 'Apartment 2 Unfurnished',
		},
		'House 4': {
			imgs: [
				{
					url: 'https://i.postimg.cc/FzC7MZhw/bathroom.webp',
					label: 'Bathroom',
				},
				{
					url: 'https://i.postimg.cc/9XLRwWy1/entry.webp',
					label: 'Entrance',
				},
				{
					url: 'https://i.postimg.cc/cLnrzw25/kitchen.webp',
					label: 'Kitchen',
				},
				{
					url: 'https://i.postimg.cc/8CgjgsVk/livingroom.webp',
					label: 'Living Room',
				},
				{
					url: 'https://i.postimg.cc/CLtRJmPq/room1.webp',
					label: 'Room 1',
				},
				{
					url: 'https://i.postimg.cc/YSNjrkp6/room2.webp',
					label: 'Room 2',
				},
			],
			doorOffset: {
				y: 0.0,
				z: 0.0,
				heading: 0.0,
				width: 2.0,
				x: 0.0,
			},
			hash: -775821472,
			label: 'House 4',
		},
		'House 1': {
			imgs: [
				{
					url: 'https://i.postimg.cc/Df96DdYt/bathroom.webp',
					label: 'Bathroom',
				},
				{
					url: 'https://i.postimg.cc/Pr1ykpgN/diningroom.webp',
					label: 'Dining Room',
				},
				{
					url: 'https://i.postimg.cc/HLk95SV7/entry.webp',
					label: 'Entrance',
				},
				{
					url: 'https://i.postimg.cc/CxYNMM07/kitchen.webp',
					label: 'Kitchen',
				},
				{
					url: 'https://i.postimg.cc/P54MCGrj/livingroom.webp',
					label: 'Living Room',
				},
				{
					url: 'https://i.postimg.cc/FKCgxjLC/room1.webp',
					label: 'Room 1',
				},
				{
					url: 'https://i.postimg.cc/sXBPHvPj/room2.webp',
					label: 'Room 2',
				},
			],
			doorOffset: {
				y: 0.0,
				z: 0.0,
				heading: 0.0,
				width: 2.0,
				x: 0.0,
			},
			hash: 1094270725,
			label: 'House 1',
		},
		Container: {
			imgs: [
				{
					url: 'https://i.postimg.cc/PxK48W5q/container.webp',
					label: 'Container',
				},
			],
			doorOffset: {
				y: 0.0,
				z: 0.0,
				heading: 0.0,
				width: 2.0,
				x: 0.0,
			},
			hash: -927040141,
			label: 'Container',
		},
		Warehouse: {
			imgs: [
				{
					url: 'https://i.postimg.cc/m2gnVrvq/angle1.webp',
					label: 'Angle 1',
				},
				{
					url: 'https://i.postimg.cc/sDHNLry2/angle2.webp',
					label: 'Angle 2',
				},
			],
			doorOffset: {
				y: 0.0,
				z: 0.0,
				heading: 0.0,
				width: 2.0,
				x: 0.0,
			},
			hash: -2113727952,
			label: 'Warehouse',
		},
		'Apartment Unfurnished': {
			imgs: [
				{
					url: 'https://i.postimg.cc/3NstF2PQ/bathroom.webp',
					label: 'Bathroom',
				},
				{
					url: 'https://i.postimg.cc/WpdjSjQ5/bedroom.webp',
					label: 'Bedroom',
				},
				{
					url: 'https://i.postimg.cc/QNvDywDh/entry.webp',
					label: 'Entrance',
				},
				{
					url: 'https://i.postimg.cc/nhJJHmMW/kitchen.webp',
					label: 'Kitchen',
				},
				{
					url: 'https://i.postimg.cc/ZK3mtHY3/livingroom.webp',
					label: 'Living Room',
				},
			],
			doorOffset: {
				y: -10.25,
				z: 0.0,
				heading: 0.0,
				width: 1.5,
				x: 1.44,
			},
			hash: 276092861,
			label: 'Apartment Unfurnished',
		},
		'Apartment Furnished': {
			imgs: [
				{
					url: 'https://i.postimg.cc/g2PYn8XR/bathroom.webp',
					label: 'Bathroom',
				},
				{
					url: 'https://i.postimg.cc/zBMN5gYy/Bedroom.webp',
					label: 'Bedroom',
				},
				{
					url: 'https://i.postimg.cc/MTXwhYNk/entry.webp',
					label: 'Entrance',
				},
				{
					url: 'https://i.postimg.cc/GtyCpmbq/Kitchen-and-Dining.webp',
					label: 'Kitchen and Dining',
				},
				{
					url: 'https://i.postimg.cc/ThvX5vwG/living-room-1.webp',
					label: 'Living Room Angle 1',
				},
				{
					url: 'https://i.postimg.cc/dQkkCR1S/living-room-2.webp',
					label: 'Living Room Angle 2',
				},
			],
			doorOffset: {
				y: -10.25,
				z: 0.0,
				heading: 0.0,
				width: 1.5,
				x: 1.44,
			},
			hash: 1205338731,
			label: 'Apartment Furnished',
		},
	}

	debugData([
		{
			action: 'setShells',
			data: debugShells,
		},
	])
</script>
