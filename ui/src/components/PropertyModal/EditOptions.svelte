<script lang="ts">
	import {
		TEMP_HIDE,
		PROPERTIES,
		SHELLS,
		REALTOR_GRADE,
		CONFIG,
	} from '@store/stores'
	import type { IProperty } from '@typings/type'
	import { ReceiveNUI } from '@utils/ReceiveNUI'
	import { SendNUI } from '@utils/SendNUI'

	export let selectedProperty: IProperty = null

	const propertyId = selectedProperty.property_id
	const index = $PROPERTIES.findIndex(
		(property) => property.property_id === propertyId
	)

	let openSellToSrc: boolean = false
	let tempSellToSrc: string = ''

	let editIsForSale: boolean = false
	let tempIsForSale: boolean = selectedProperty.for_sale ? true : false

	let editingDescription: boolean = false
	let tempNewDescription: string = selectedProperty.description

	let editingPrice: boolean = false
	let tempNewPrice: number = selectedProperty.price

	let editingShell: boolean = false
	let tempNewShell: string = selectedProperty.shell

	let editingImages: boolean = false
	let tempNewImages: any[] = selectedProperty.extra_imgs
	let tempNewImageLabel: string = ''
	let tempNewImageUrl: string = ''

	let deletingProperty: boolean = false

	ReceiveNUI('garageMade', (data: any) => {
		selectedProperty.garage_data = data
	})
</script>

{#if selectedProperty !== null}
	<div
		class="flex flex-col gap-4 h-full overflow-y-scroll scroll-style scroll-style-vertical w-full"
	>
		<h1 class="text-3xl font-bold mb-2">Manage Property</h1>
		{#if $REALTOR_GRADE >= $CONFIG.changePropertyForSale}
			<div class="flex flex-row gap-2 items-center">
				<p class="text-2xl font-bold">Set Property For Sale</p>
				<div
					class="flex flex-row w-fit gap-4 items-center justify-center"
				>
					<button
						class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
						on:click={() => (editIsForSale = !editIsForSale)}
					>
						<i
							class="fas fa-caret-{editIsForSale ? 'up' : 'down'}"
						/>
						<p>Open</p>
					</button>
				</div>
			</div>
			{#if editIsForSale}
				<div class="flex flex-row gap-2 items-center">
					<select
						class="text-2xl bg-[color:var(--color-tertiary)] p-2"
						bind:value={tempIsForSale}
					>
						<option value={true}>For Sale</option>
						<option value={false}>Not For Sale</option>
					</select>
					<button
						class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
						on:click={() => {
							SendNUI('updatePropertyData', {
								type: 'UpdateForSale',
								property_id: selectedProperty.property_id,
								data: {forsale: tempIsForSale},
							})
							$PROPERTIES[index].for_sale = tempIsForSale ? 1 : 0
							selectedProperty.for_sale = tempIsForSale ? 1 : 0
						}}
					>
						<i class="fas fa-check" />
						<p>
							{tempIsForSale == true
								? 'Set For Sale'
								: 'Set Not For Sale'}
						</p>
					</button>
				</div>
			{/if}
		{/if}

		{#if $REALTOR_GRADE >= $CONFIG.sellProperty}
			{#if selectedProperty.for_sale == 1}
				<div class="flex flex-row gap-2 items-center">
					<p class="text-2xl font-bold">Finalise Sell Property</p>
					<div
						class="flex flex-row w-fit gap-4 items-center justify-center"
					>
						<button
							class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
							on:click={() => (openSellToSrc = !openSellToSrc)}
						>
							<i
								class="fas fa-caret-{openSellToSrc
									? 'up'
									: 'down'}"
							/>
							<p>Open</p>
						</button>
					</div>
				</div>
				{#if openSellToSrc}
					<div class="flex flex-row gap-2 items-center">
						<input
							type="text"
							placeholder="ID"
							class="text-2xl bg-[color:var(--color-tertiary)] p-2"
							bind:value={tempSellToSrc}
						/>
						<button
							class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
							on:click={() => {
								SendNUI('updatePropertyData', {
									type: 'UpdateOwner',
									property_id: selectedProperty.property_id,
									data: {targetSrc: tempSellToSrc},
								})
								$PROPERTIES[index].owner = tempSellToSrc
								selectedProperty.owner = tempSellToSrc
							}}
						>
							<i class="fas fa-check" />
							<p>
								Finalise Sell For ${selectedProperty.price.toLocaleString()}
							</p>
						</button>
					</div>
				{/if}
			{/if}
		{/if}

		<div class="flex flex-row gap-2 items-center">
			<p class="text-2xl font-bold">Manage Description</p>
			<div class="flex flex-row w-fit gap-4 items-center justify-center">
				<button
					class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
					on:click={() => (editingDescription = !editingDescription)}
				>
					<i
						class="fas fa-caret-{editingDescription
							? 'up'
							: 'down'}"
					/>
					<i class="fas fa-pen" />
					<p>Edit</p>
				</button>
			</div>
		</div>
		{#if editingDescription}
			<div class="flex flex-row gap-2 items-center">
				<textarea
					placeholder="Description"
					class="text-2xl bg-[color:var(--color-tertiary)] p-2"
					bind:value={tempNewDescription}
				/>
				<button
					class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
					on:click={() => {
						SendNUI('updatePropertyData', {
							type: 'UpdateDescription',
							property_id: selectedProperty.property_id,
							data: {description: tempNewDescription},
						})
						$PROPERTIES[index].description = tempNewDescription
						selectedProperty.description = tempNewDescription
					}}
				>
					<i class="fas fa-check" />
					<p>Save</p>
				</button>
			</div>
		{/if}

		<div class="flex flex-row gap-2 items-center">
			<p class="text-2xl font-bold">Manage Price</p>
			<div class="flex flex-row w-fit gap-4 items-center justify-center">
				<button
					class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
					on:click={() => (editingPrice = !editingPrice)}
				>
					<i class="fas fa-caret-{editingPrice ? 'up' : 'down'}" />
					<i class="fas fa-pen" />
					<p>Edit</p>
				</button>
			</div>
		</div>
		{#if editingPrice}
			<div class="flex flex-row gap-2 items-center">
				$<input
					type="number"
					placeholder="Price"
					class="text-2xl bg-[color:var(--color-tertiary)] p-2"
					bind:value={tempNewPrice}
				/>
				<button
					class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
					on:click={() => {
						SendNUI('updatePropertyData', {
							type: 'UpdatePrice',
							property_id: selectedProperty.property_id,
							data: {price: tempNewPrice},
						})
						$PROPERTIES[index].price = tempNewPrice
						selectedProperty.price = tempNewPrice
					}}
				>
					<i class="fas fa-check" />
					<p>Save</p>
				</button>
			</div>
		{/if}

		<div class="flex flex-row gap-2 items-center">
			<p class="text-2xl font-bold">Manage Shell</p>
			<div class="flex flex-row w-fit gap-4 items-center justify-center">
				<button
					class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
					on:click={() => (editingShell = !editingShell)}
				>
					<i class="fas fa-caret-{editingShell ? 'up' : 'down'}" />
					<i class="fas fa-pen" />
					<p>Edit</p>
				</button>
			</div>
		</div>
		{#if editingShell}
			<div class="flex flex-row gap-2 items-center">
				<select
					class="text-2xl bg-[color:var(--color-tertiary)] p-2"
					bind:value={tempNewShell}
				>
					{#each Object.keys($SHELLS) as shell}
						<option value={shell}>{shell}</option>
					{/each}
				</select>
				<button
					class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
					on:click={() => {
						SendNUI('updatePropertyData', {
							type: 'UpdateShell',
							property_id: selectedProperty.property_id,
							data: {shell: tempNewShell},
						}).then((res) => {
    				  	if (res === "ok") {
							$PROPERTIES[index].shell = tempNewShell
							selectedProperty.shell = tempNewShell
    				  	} else {
    				  	  console.log('Invalid Shell')
    				  	}
    					});
					}}
				>
					<i class="fas fa-check" />
					<p>Save</p>
				</button>
			</div>
		{/if}

		<div class="flex flex-row gap-2 items-center">
			<p class="text-2xl font-bold">Manage Extra Images</p>
			<div class="flex flex-row w-fit gap-4 items-center justify-center">
				<button
					class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
					on:click={() => (editingImages = !editingImages)}
				>
					<i class="fas fa-caret-{editingImages ? 'up' : 'down'}" />
					<i class="fas fa-pen" />
					<p>Edit</p>
				</button>
			</div>
		</div>
		{#if editingImages}
			{#each tempNewImages as img, i}
				<div
					class="w-[100%] bg-[color:var(--color-tertiary)] flex flex-col gap-2 items-center justify-center p-2"
				>
					<img class="w-[100%] object-cover" src={img.url} alt="Show Images" />
					<p class="text-2xl">{img.label}</p>
					<div class="flex flex-row gap-4">
						<button
							class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
							on:click={() => {
								tempNewImages = tempNewImages.filter(
									(i) => i.url !== img.url
								)
								SendNUI('updatePropertyData', {
									type: 'UpdateImages',
									property_id: selectedProperty.property_id,
									data: {imgs: tempNewImages},
								})
								$PROPERTIES[index].extra_imgs = tempNewImages
								selectedProperty.extra_imgs = tempNewImages
							}}
						>
							<i class="fas fa-trash" />
							<p>Remove</p>
						</button>
						<!-- shift up in array -->
						{#if i !== 0}
							<button
								class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
								on:click={() => {
									const index = tempNewImages.findIndex(
										(i) => i.url === img.url
									)
									if (index === 0) return
									const temp = tempNewImages[index - 1]
									tempNewImages[index - 1] =
										tempNewImages[index]
									tempNewImages[index] = temp
									SendNUI('updatePropertyData', {
										type: 'UpdateImages',
										property_id:
											selectedProperty.property_id,
										data: {img: tempNewImages},
									})
									$PROPERTIES[index].extra_imgs =
										tempNewImages
									selectedProperty.extra_imgs = tempNewImages
								}}
							>
								<i class="fas fa-arrow-up" />
								<p>Shift Up</p>
							</button>
						{/if}
						<!-- shift down in array -->
						{#if i !== tempNewImages.length - 1}
							<button
								class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
								on:click={() => {
									const index = tempNewImages.findIndex(
										(i) => i.url === img.url
									)
									if (index === tempNewImages.length - 1)
										return
									const temp = tempNewImages[index + 1]
									tempNewImages[index + 1] =
										tempNewImages[index]
									tempNewImages[index] = temp
									SendNUI('updatePropertyData', {
										type: 'UpdateImages',
										property_id:
											selectedProperty.property_id,
										data: {imgs: tempNewImages},
									})
									$PROPERTIES[index].extra_imgs =
										tempNewImages
									selectedProperty.extra_imgs = tempNewImages
								}}
							>
								<i class="fas fa-arrow-down" />
								<p>Shift Down</p>
							</button>
						{/if}
					</div>
				</div>
			{/each}
			<div class="flex flex-row gap-2 items-center">
				<input
					type="text"
					placeholder="Label"
					class="text-2xl bg-[color:var(--color-tertiary)] p-2"
					bind:value={tempNewImageLabel}
				/>
				<input
					type="text"
					placeholder="URL"
					class="text-2xl bg-[color:var(--color-tertiary)] p-2"
					bind:value={tempNewImageUrl}
				/>
				<div class="flex flex-row gap-4">
					<button
						class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
						on:click={() => {
							tempNewImages = [
								...tempNewImages,
								{
									label: tempNewImageLabel,
									url: tempNewImageUrl,
								},
							]
							tempNewImageLabel = ''
							tempNewImageUrl = ''
							SendNUI('updatePropertyData', {
								type: 'UpdateImages',
								property_id: selectedProperty.property_id,
								data: {imgs: tempNewImages},
							})
							$PROPERTIES[index].extra_imgs = tempNewImages
							selectedProperty.extra_imgs = tempNewImages
						}}
					>
						<i class="fas fa-plus" />
						<p>Add</p>
					</button>
				</div>
			</div>
		{/if}

		<div class="flex flex-row gap-2 items-center">
			<p class="text-2xl font-bold">Manage Door</p>
			<div class="flex flex-row w-fit gap-4 items-center justify-center">
				<button
					class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
					on:click={() => {
						SendNUI('startZonePlacement', {
							type: 'door',
							property_id: selectedProperty.property_id,
						}).then(() => {
							$TEMP_HIDE = true
						})
					}}
				>
					<i class="fas fa-pen" />
					<p>Edit</p>
				</button>
			</div>
		</div>
		<div class="flex flex-row gap-2 items-center">
			<p class="text-2xl font-bold">Manage Garage</p>
			{#if selectedProperty.garage_data ? (selectedProperty.garage_data.x ? true : false) : false}
				<!-- {#if true} -->
				<div
					class="flex flex-row w-fit gap-4 items-center justify-center"
				>
					<button
						class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
						on:click={() => {
							SendNUI('startZonePlacement', {
								type: 'garage',
								property_id: selectedProperty.property_id,
							}).then(() => {
								$TEMP_HIDE = true
							})
						}}
					>
						<i class="fas fa-pen" />
						<p>Move</p>
					</button>
					<button
						class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
						on:click={() => {
							SendNUI('updatePropertyData', {
								type: 'UpdateGarage',
								property_id: selectedProperty.property_id,
								data: {},
							})
							$PROPERTIES[index].garage_data = null
							selectedProperty.garage_data = null
						}}
					>
						<i class="fas fa-times" />
						<p>Remove</p>
					</button>
				</div>
			{:else}
				<button
					class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
					on:click={() => {
						SendNUI('startZonePlacement', {
							type: 'garage',
							property_id: selectedProperty.property_id,
						}).then(() => {
							$TEMP_HIDE = true
						})
					}}
				>
					<i class="fas fa-plus" />
					<p>Add</p>
				</button>
			{/if}
		</div>

		{#if $REALTOR_GRADE >= $CONFIG.deleteProperty}
			<div class="flex flex-row gap-2 items-center">
				<p class="text-2xl font-bold">Delete Property</p>
				<div
					class="flex flex-row w-fit gap-4 items-center justify-center"
				>
					<button
						class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
						on:click={() => (deletingProperty = !deletingProperty)}
					>
						<i
							class="fas fa-caret-{deletingProperty
								? 'up'
								: 'down'}"
						/>
						<p>Click to open option</p>
					</button>
				</div>
			</div>

			{#if deletingProperty}
				<button
					class="bg-[color:var(--color-tertiary)] flex flex-row items-center justify-center gap-2 p-2"
					on:click={() => {
						if (selectedProperty == null) return
						SendNUI('updatePropertyData', {
							type: 'DeleteProperty',
							property_id: selectedProperty.property_id,
							data: {},
						})
						$PROPERTIES.splice(index, 1)
						selectedProperty = null
					}}
				>
					<i class="fas fa-times" />
					<p>DELETE (NO UNDO)</p>
				</button>
			{/if}
		{/if}
	</div>
{/if}
