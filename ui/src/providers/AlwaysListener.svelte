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
						url: 'https://users-cdn.versescripts.net/68fe5fd70ca9bd96640da4c31fdb573f.png',
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
						url: 'https://users-cdn.versescripts.net/af4ec0dfd72f9cad377a5091f8ffa806.png',
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
					url: 'https://files.fivemerr.com/images/6c6fda4c-1f03-4ccb-b9e0-22ba358e6821.webp',
					label: 'Entrance',
				},
				{
					url: 'https://files.fivemerr.com/images/c5aecca6-7831-497a-ad3e-dcf06f7db4f6.webp',
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
					url: 'https://files.fivemerr.com/images/d9501f26-81d1-46d6-81cd-56a0345a3c1b.jpeg',
					label: 'Angle 1',
				},
				{
					url: 'https://files.fivemerr.com/images/480bc73e-977e-417a-b70b-78fc337dec69.jpeg',
					label: 'Angle 2',
				},
				{
					url: 'https://files.fivemerr.com/images/e8bec3f0-0d87-4ccd-9ff1-6b6a1141c097.jpeg',
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
					url: 'https://files.fivemerr.com/images/454ae047-3948-41aa-bea2-e276ed99aec6.webp',
					label: 'Room 1',
				},
				{
					url: 'https://files.fivemerr.com/images/bbd41423-2782-4597-9320-d45590abe327.webp',
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
					url: 'https://files.fivemerr.com/images/eaf77207-da0e-4bd1-be03-324ba0e2ffdc.webp',
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
					url: 'https://files.fivemerr.com/images/e21b7997-c86e-435a-9140-a319c65e5ad8.webp',
					label: 'Angle 1',
				},
				{
					url: 'https://files.fivemerr.com/images/27a59fc9-2739-4a0d-a1a2-020a5e849389.webp',
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
					url: 'https://files.fivemerr.com/images/b9813f35-ce5d-4ebd-a4b2-d538628dcd20.webp',
					label: 'Bathroom',
				},
				{
					url: 'https://files.fivemerr.com/images/eadb895d-9186-4b08-b50d-6c4e08fef952.webp',
					label: 'Entrance',
				},
				{
					url: 'https://files.fivemerr.com/images/5320e158-010e-4ac3-9e93-3fe08b150486.webp',
					label: 'Floor 2',
				},
				{
					url: 'https://files.fivemerr.com/images/95a36c06-a00a-4d84-aa3d-439f51e99d8f.webp',
					label: 'Kitchen',
				},
				{
					url: 'https://files.fivemerr.com/images/74f9a597-1643-48e3-a215-b347a01a74de.webp',
					label: 'Living Room',
				},
				{
					url: 'https://files.fivemerr.com/images/572734b6-e68c-46c1-9693-86e20e393a10.webp',
					label: 'Room 1',
				},
				{
					url: 'https://files.fivemerr.com/images/a64ddbfe-c374-465c-89c1-363588ab25e0.webp',
					label: 'Room 2',
				},
				{
					url: 'https://files.fivemerr.com/images/ec212d2b-107c-4da7-aea2-d61139cc6bef.webp',
					label: 'Room 3',
				},
				{
					url: 'https://files.fivemerr.com/images/fdd207a7-ec15-44b2-9dde-347aaa7cfd67.webp',
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
					url: 'https://files.fivemerr.com/images/9c55b4d8-d529-4d7e-b3c3-9c6abe8e3cca.webp',
					label: 'Entrance and Kitchen',
				},
				{
					url: 'https://files.fivemerr.com/images/4677d95d-d6b1-4577-ab8a-6d08f6401445.webp',
					label: 'Main',
				},
				{
					url: 'https://files.fivemerr.com/images/5c0eac55-d394-49b2-b2de-e9d31d9bb7c8.webp',
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
					url: 'https://files.fivemerr.com/images/eb936202-0bf2-468b-809a-625ccba14698.webp',
					label: 'Entrance',
				},
				{
					url: 'https://files.fivemerr.com/images/9e8ac33b-d71d-4ed9-81cc-e1b407d86e76.webp',
					label: 'Hallway',
				},
				{
					url: 'https://files.fivemerr.com/images/b5fe556f-efa7-4048-a0f3-8e604d885fb4.webp',
					label: 'Kitchen',
				},
				{
					url: 'https://files.fivemerr.com/images/e9728ca8-24c5-4915-9329-3fccb59450dd.webp',
					label: 'Main Area',
				},
				{
					url: 'https://files.fivemerr.com/images/31fbd065-6789-4106-a667-7a73c557486b.webp',
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
					url: 'https://files.fivemerr.com/images/d8987d5a-af22-4927-aae0-3c69f75038d3.webp',
					label: 'Entance',
				},
				{
					url: 'https://files.fivemerr.com/images/b1f584b8-0570-4400-b868-30cd2d7fd17f.webp',
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
					url: 'https://files.fivemerr.com/images/febe4d12-7432-4da6-ad6a-1957c74f8024.webp',
					label: 'Entrance',
				},
				{
					url: 'https://files.fivemerr.com/images/a74b3377-81ca-4df3-9bd0-e4f0828f78bf.webp',
					label: 'Kitchen',
				},
				{
					url: 'https://files.fivemerr.com/images/66eb8b85-e0c7-4065-b230-32410772260a.webp',
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
					url: 'https://files.fivemerr.com/images/e709bb71-7d05-476c-81d8-c42ef53025f5.webp',
					label: 'Bathroom',
				},
				{
					url: 'https://files.fivemerr.com/images/516ec833-2c14-49a2-8f5d-13c6d3cd2651.webp',
					label: 'Entrance',
				},
				{
					url: 'https://files.fivemerr.com/images/186a0e06-4e57-4bd6-9ff7-c05ae2557638.webp',
					label: 'Kitchen',
				},
				{
					url: 'https://files.fivemerr.com/images/5c1461f0-bcef-4f23-828b-a78ffca86c0c.webp',
					label: 'Living Room',
				},
				{
					url: 'https://files.fivemerr.com/images/a74b278c-ece9-4287-9d60-6b7deb752463.webp',
					label: 'Room 1',
				},
				{
					url: 'https://files.fivemerr.com/images/3e2c7ae3-3166-47a7-9991-9ab749f7ff29.webp',
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
					url: 'https://files.fivemerr.com/images/d0557708-bb57-4dea-b8c7-8ec34c8391a4.webp',
					label: 'Bathroom',
				},
				{
					url: 'https://files.fivemerr.com/images/81b849bb-c722-42f3-865b-a5c20da6d1be.webp',
					label: 'Dining Room',
				},
				{
					url: 'https://files.fivemerr.com/images/c795a770-fb95-4838-9d12-182ebfefc681.webp',
					label: 'Entrance',
				},
				{
					url: 'https://files.fivemerr.com/images/a095ee16-c074-41a3-9c6a-d56fb8ce3a47.webp',
					label: 'Kitchen',
				},
				{
					url: 'https://files.fivemerr.com/images/ad22df64-4d64-4fde-b0ba-5dcaa0659d97.webp',
					label: 'Living Room',
				},
				{
					url: 'https://files.fivemerr.com/images/fc96a826-048a-4dda-a825-2fa43b8f7179.webp',
					label: 'Room 1',
				},
				{
					url: 'https://files.fivemerr.com/images/e7292195-e518-49e7-9ba8-284b8f2dcc30.webp',
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
					url: 'https://files.fivemerr.com/images/6c7cdceb-7106-4559-97e6-bcc58e24ce9b.webp',
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
					url: 'https://files.fivemerr.com/images/4f39ffc7-6de4-435a-a1a3-b0e9493c43fd.webp',
					label: 'Angle 1',
				},
				{
					url: 'https://files.fivemerr.com/images/a6c7e4ed-ff81-4b30-adca-89d51f5ee64e.webp',
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
					url: 'https://files.fivemerr.com/images/90238f10-e65e-4c89-a879-6be664194258.webp',
					label: 'Bathroom',
				},
				{
					url: 'https://files.fivemerr.com/images/edfcda70-bca6-419c-84b5-11e173e9edc3.webp',
					label: 'Bedroom',
				},
				{
					url: 'https://files.fivemerr.com/images/aed9c846-7314-4869-948f-3262e1d141ee.webp',
					label: 'Entrance',
				},
				{
					url: 'https://files.fivemerr.com/images/a51a4844-2141-472f-bde2-0c07a940ddd0.webp',
					label: 'Kitchen',
				},
				{
					url: 'https://files.fivemerr.com/images/bcbc0b02-5648-4eb2-bd16-5585a2f14e12.webp',
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
					url: 'https://files.fivemerr.com/images/36e5d763-a00f-44a7-a114-82d054073320.webp',
					label: 'Bathroom',
				},
				{
					url: 'https://files.fivemerr.com/images/263234eb-479e-4b6e-9aeb-6640c25f7672.webp',
					label: 'Bedroom',
				},
				{
					url: 'https://files.fivemerr.com/images/eacbe324-d2d6-4312-8fae-15eff63ad1fc.webp',
					label: 'Entrance',
				},
				{
					url: 'https://files.fivemerr.com/images/62051872-d44d-4bd0-ba0f-f8a4607a9e3d.webp',
					label: 'Kitchen and Dining',
				},
				{
					url: 'https://files.fivemerr.com/images/4ffd2c5c-78ad-454e-bc58-e66cd94c5b35.webp',
					label: 'Living Room Angle 1',
				},
				{
					url: 'https://files.fivemerr.com/images/1a628bcc-ded2-4902-97f2-b6e6862d2d65.webp',
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
